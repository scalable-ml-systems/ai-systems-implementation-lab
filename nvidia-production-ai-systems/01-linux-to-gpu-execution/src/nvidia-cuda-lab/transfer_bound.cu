#include <cuda_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#define CHECK(call) do {                                             \
    cudaError_t err = (call);                                        \
    if (err != cudaSuccess) {                                        \
        std::fprintf(stderr, "%s:%d: %s\n",                          \
                     __FILE__, __LINE__, cudaGetErrorString(err));   \
        std::exit(EXIT_FAILURE);                                     \
    }                                                                \
} while (0)

__global__ void tiny_kernel(int* data) {
    if (threadIdx.x == 0 && blockIdx.x == 0) {
        data[0] += 1;
    }
}

struct PipelineResult {
    float h2d_ms;
    float kernel_ms;
    float d2h_ms;
    float total_ms;
};

PipelineResult benchmark_pipeline(
    void* h_buffer,
    int* d_buffer,
    size_t bytes,
    int iters
) {
    cudaStream_t stream;
    cudaEvent_t total_start, h2d_done, kernel_done, d2h_done;

    CHECK(cudaStreamCreate(&stream));
    CHECK(cudaEventCreate(&total_start));
    CHECK(cudaEventCreate(&h2d_done));
    CHECK(cudaEventCreate(&kernel_done));
    CHECK(cudaEventCreate(&d2h_done));

    // Warm-up: excluded from measurements.
    CHECK(cudaMemcpyAsync(
        d_buffer, h_buffer, bytes, cudaMemcpyHostToDevice, stream
    ));
    tiny_kernel<<<1, 1, 0, stream>>>(d_buffer);
    CHECK(cudaGetLastError());
    CHECK(cudaMemcpyAsync(
        h_buffer, d_buffer, bytes, cudaMemcpyDeviceToHost, stream
    ));
    CHECK(cudaStreamSynchronize(stream));

    float h2d_total_ms = 0.0f;
    float kernel_total_ms = 0.0f;
    float d2h_total_ms = 0.0f;
    float total_total_ms = 0.0f;

    for (int i = 0; i < iters; ++i) {
        CHECK(cudaEventRecord(total_start, stream));

        CHECK(cudaMemcpyAsync(
            d_buffer, h_buffer, bytes, cudaMemcpyHostToDevice, stream
        ));
        CHECK(cudaEventRecord(h2d_done, stream));

        tiny_kernel<<<1, 1, 0, stream>>>(d_buffer);
        CHECK(cudaGetLastError());
        CHECK(cudaEventRecord(kernel_done, stream));

        CHECK(cudaMemcpyAsync(
            h_buffer, d_buffer, bytes, cudaMemcpyDeviceToHost, stream
        ));
        CHECK(cudaEventRecord(d2h_done, stream));

        CHECK(cudaEventSynchronize(d2h_done));

        float ms = 0.0f;

        CHECK(cudaEventElapsedTime(&ms, total_start, h2d_done));
        h2d_total_ms += ms;

        CHECK(cudaEventElapsedTime(&ms, h2d_done, kernel_done));
        kernel_total_ms += ms;

        CHECK(cudaEventElapsedTime(&ms, kernel_done, d2h_done));
        d2h_total_ms += ms;

        CHECK(cudaEventElapsedTime(&ms, total_start, d2h_done));
        total_total_ms += ms;
    }

    CHECK(cudaEventDestroy(total_start));
    CHECK(cudaEventDestroy(h2d_done));
    CHECK(cudaEventDestroy(kernel_done));
    CHECK(cudaEventDestroy(d2h_done));
    CHECK(cudaStreamDestroy(stream));

    return {
        h2d_total_ms / iters,
        kernel_total_ms / iters,
        d2h_total_ms / iters,
        total_total_ms / iters
    };
}

int main() {
    constexpr size_t bytes = 256ULL * 1024 * 1024;
    constexpr int iters = 100;

    void* h_pageable = std::malloc(bytes);
    void* h_pinned = nullptr;
    int* d_buffer = nullptr;

    if (!h_pageable) {
        std::fprintf(stderr, "Pageable host allocation failed\n");
        return EXIT_FAILURE;
    }

    CHECK(cudaMallocHost(&h_pinned, bytes));
    CHECK(cudaMalloc(&d_buffer, bytes));

    // First-touch allocations before timing.
    std::memset(h_pageable, 0xA5, bytes);
    std::memset(h_pinned, 0x5A, bytes);
    CHECK(cudaMemset(d_buffer, 0, bytes));
    CHECK(cudaDeviceSynchronize());

    PipelineResult pageable =
        benchmark_pipeline(h_pageable, d_buffer, bytes, iters);

    PipelineResult pinned =
        benchmark_pipeline(h_pinned, d_buffer, bytes, iters);

    std::printf(
        "| Memory type | H2D ms | Kernel ms | D2H ms | Total ms |\n"
    );
    std::printf(
        "|---|---:|---:|---:|---:|\n"
    );
    std::printf(
        "| Pageable | %.3f | %.6f | %.3f | %.3f |\n",
        pageable.h2d_ms,
        pageable.kernel_ms,
        pageable.d2h_ms,
        pageable.total_ms
    );
    std::printf(
        "| Pinned | %.3f | %.6f | %.3f | %.3f |\n",
        pinned.h2d_ms,
        pinned.kernel_ms,
        pinned.d2h_ms,
        pinned.total_ms
    );

    CHECK(cudaFree(d_buffer));
    CHECK(cudaFreeHost(h_pinned));
    std::free(h_pageable);

    return EXIT_SUCCESS;
}
