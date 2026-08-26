#include <cuda_runtime.h>

#include <cstdlib>
#include <iostream>

#define CUDA_CHECK(call)                                                   \
    do {                                                                   \
        cudaError_t error = (call);                                        \
        if (error != cudaSuccess) {                                        \
            std::cerr                                                     \
                << "CUDA error: "                                          \
                << cudaGetErrorString(error)                               \
                << '\n';                                                   \
            std::exit(EXIT_FAILURE);                                      \
        }                                                                  \
    } while (0)

int main() {
    const size_t bytes = 256ULL * 1024 * 1024;

    // Allocate pageable host memory.
    void* h_buffer = std::malloc(bytes);

    if (!h_buffer) {
        std::cerr << "Host allocation failed\n";
        return EXIT_FAILURE;
    }

    // Allocate device memory in GPU HBM / VRAM.
    void* d_buffer = nullptr;

    CUDA_CHECK(
        cudaMalloc(&d_buffer, bytes)
    );

    cudaEvent_t start;
    cudaEvent_t stop;

    CUDA_CHECK(cudaEventCreate(&start));
    CUDA_CHECK(cudaEventCreate(&stop));

    // Host → Device transfer.
    CUDA_CHECK(cudaEventRecord(start));

    CUDA_CHECK(
        cudaMemcpy(
            d_buffer,
            h_buffer,
            bytes,
            cudaMemcpyHostToDevice
        )
    );

    CUDA_CHECK(cudaEventRecord(stop));
    CUDA_CHECK(cudaEventSynchronize(stop));

    float h2d_ms = 0.0f;

    CUDA_CHECK(
        cudaEventElapsedTime(
            &h2d_ms,
            start,
            stop
        )
    );

    // Device → Host transfer.
    CUDA_CHECK(cudaEventRecord(start));

    CUDA_CHECK(
        cudaMemcpy(
            h_buffer,
            d_buffer,
            bytes,
            cudaMemcpyDeviceToHost
        )
    );

    CUDA_CHECK(cudaEventRecord(stop));
    CUDA_CHECK(cudaEventSynchronize(stop));

    float d2h_ms = 0.0f;

    CUDA_CHECK(
        cudaEventElapsedTime(
            &d2h_ms,
            start,
            stop
        )
    );

    const double gb =
        static_cast<double>(bytes) / 1e9;

    const double h2d_gbps =
        gb / (h2d_ms / 1000.0);

    const double d2h_gbps =
        gb / (d2h_ms / 1000.0);

    std::cout
        << "Transfer size: "
        << gb
        << " GB\n";

    std::cout
        << "H2D: "
        << h2d_ms
        << " ms, "
        << h2d_gbps
        << " GB/s\n";

    std::cout
        << "D2H: "
        << d2h_ms
        << " ms, "
        << d2h_gbps
        << " GB/s\n";

    CUDA_CHECK(cudaEventDestroy(start));
    CUDA_CHECK(cudaEventDestroy(stop));
    CUDA_CHECK(cudaFree(d_buffer));

    std::free(h_buffer);

    return EXIT_SUCCESS;
}
