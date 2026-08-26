#include <cuda_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#define CHECK(call) do {                                      \
    cudaError_t err = (call);                                 \
    if (err != cudaSuccess) {                                 \
        std::fprintf(stderr, "%s:%d: %s\n",                   \
                     __FILE__, __LINE__, cudaGetErrorString(err)); \
        std::exit(EXIT_FAILURE);                              \
    }                                                         \
} while (0)

struct Result {
    float h2d_ms;
    double h2d_gbps;
    float d2h_ms;
    double d2h_gbps;
};

Result benchmark(void* h, void* d, size_t bytes, int iters) {
    cudaEvent_t start, stop;
    CHECK(cudaEventCreate(&start));
    CHECK(cudaEventCreate(&stop));

    // Warm up both directions.
    CHECK(cudaMemcpy(d, h, bytes, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(h, d, bytes, cudaMemcpyDeviceToHost));
    CHECK(cudaDeviceSynchronize());

    // H2D
    CHECK(cudaEventRecord(start));
    for (int i = 0; i < iters; ++i)
        CHECK(cudaMemcpy(d, h, bytes, cudaMemcpyHostToDevice));
    CHECK(cudaEventRecord(stop));
    CHECK(cudaEventSynchronize(stop));

    float h2d_ms = 0.0f;
    CHECK(cudaEventElapsedTime(&h2d_ms, start, stop));

    // D2H
    CHECK(cudaEventRecord(start));
    for (int i = 0; i < iters; ++i)
        CHECK(cudaMemcpy(h, d, bytes, cudaMemcpyDeviceToHost));
    CHECK(cudaEventRecord(stop));
    CHECK(cudaEventSynchronize(stop));

    float d2h_ms = 0.0f;
    CHECK(cudaEventElapsedTime(&d2h_ms, start, stop));

    const double total_bytes = static_cast<double>(bytes) * iters;

    CHECK(cudaEventDestroy(start));
    CHECK(cudaEventDestroy(stop));

    return {
        h2d_ms / iters,
        total_bytes / (h2d_ms * 1e6),
        d2h_ms / iters,
        total_bytes / (d2h_ms * 1e6)
    };
}

int main() {
    constexpr size_t bytes = 256ULL * 1024 * 1024;
    constexpr int iters = 100;

    void* h_pageable = std::malloc(bytes);
    void* h_pinned = nullptr;
    void* d_buffer = nullptr;

    if (!h_pageable) return EXIT_FAILURE;

    CHECK(cudaMallocHost(&h_pinned, bytes));
    CHECK(cudaMalloc(&d_buffer, bytes));

    // Force physical allocation / first touch before timing.
    std::memset(h_pageable, 0xA5, bytes);
    std::memset(h_pinned,   0x5A, bytes);
    CHECK(cudaMemset(d_buffer, 0, bytes));

    Result pageable = benchmark(h_pageable, d_buffer, bytes, iters);
    Result pinned   = benchmark(h_pinned,   d_buffer, bytes, iters);

    std::printf("| Memory type | H2D ms | H2D GB/s | D2H ms | D2H GB/s |\n");
    std::printf("|---|---:|---:|---:|---:|\n");
    std::printf("| Pageable | %.3f | %.2f | %.3f | %.2f |\n",
                pageable.h2d_ms, pageable.h2d_gbps,
                pageable.d2h_ms, pageable.d2h_gbps);
    std::printf("| Pinned | %.3f | %.2f | %.3f | %.2f |\n",
                pinned.h2d_ms, pinned.h2d_gbps,
                pinned.d2h_ms, pinned.d2h_gbps);

    CHECK(cudaFree(d_buffer));
    CHECK(cudaFreeHost(h_pinned));
    std::free(h_pageable);
}
