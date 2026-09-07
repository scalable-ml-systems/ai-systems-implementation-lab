#include <cuda_runtime.h>

#include <chrono>
#include <cstdlib>
#include <iostream>

#define CUDA_CHECK(call)                                      \
do {                                                          \
    cudaError_t e = (call);                                   \
    if (e != cudaSuccess) {                                   \
        std::cerr << cudaGetErrorString(e) << "\n";           \
        std::exit(EXIT_FAILURE);                              \
    }                                                         \
} while (0)

using Clock = std::chrono::steady_clock;

__global__ void busy_kernel(unsigned long long cycles) {
    unsigned long long start = clock64();

    while (clock64() - start < cycles) {
        // deliberately keep GPU busy
    }
}

double elapsed_ms(Clock::time_point a, Clock::time_point b) {
    return std::chrono::duration<double, std::milli>(b - a).count();
}

int main() {
    const size_t bytes = 256ULL * 1024 * 1024;

    cudaDeviceProp props{};
    CUDA_CHECK(cudaGetDeviceProperties(&props, 0));

    // Roughly 200 ms of GPU work
    unsigned long long cycles =
        static_cast<unsigned long long>(
            props.clockRate * 1000ULL / 5
        );

    // Pinned host buffers
    void* h1 = nullptr;
    void* h2 = nullptr;

    CUDA_CHECK(cudaMallocHost(&h1, bytes));
    CUDA_CHECK(cudaMallocHost(&h2, bytes));

    // Device buffers
    void* d1 = nullptr;
    void* d2 = nullptr;

    CUDA_CHECK(cudaMalloc(&d1, bytes));
    CUDA_CHECK(cudaMalloc(&d2, bytes));

    cudaStream_t s1;
    cudaStream_t s2;

    CUDA_CHECK(cudaStreamCreate(&s1));
    CUDA_CHECK(cudaStreamCreate(&s2));

    // Warm up CUDA
    busy_kernel<<<1, 1>>>(1000);
    CUDA_CHECK(cudaDeviceSynchronize());

    // --------------------------------
    // 1. Sequential
    // --------------------------------

    auto seq_start = Clock::now();

    CUDA_CHECK(cudaMemcpy(
        d1, h1, bytes,
        cudaMemcpyHostToDevice
    ));

    busy_kernel<<<1, 1>>>(cycles);
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(cudaMemcpy(
        d2, h2, bytes,
        cudaMemcpyHostToDevice
    ));

    busy_kernel<<<1, 1>>>(cycles);
    CUDA_CHECK(cudaDeviceSynchronize());

    auto seq_end = Clock::now();

    // --------------------------------
    // 2. Two streams
    // --------------------------------

    auto overlap_start = Clock::now();

    CUDA_CHECK(cudaMemcpyAsync(
        d1, h1, bytes,
        cudaMemcpyHostToDevice,
        s1
    ));

    busy_kernel<<<1, 1, 0, s1>>>(cycles);

    CUDA_CHECK(cudaMemcpyAsync(
        d2, h2, bytes,
        cudaMemcpyHostToDevice,
        s2
    ));

    busy_kernel<<<1, 1, 0, s2>>>(cycles);

    CUDA_CHECK(cudaDeviceSynchronize());

    auto overlap_end = Clock::now();

    std::cout
        << "Sequential total: "
        << elapsed_ms(seq_start, seq_end)
        << " ms\n";

    std::cout
        << "Two-stream total: "
        << elapsed_ms(overlap_start, overlap_end)
        << " ms\n";

    CUDA_CHECK(cudaStreamDestroy(s1));
    CUDA_CHECK(cudaStreamDestroy(s2));

    CUDA_CHECK(cudaFree(d1));
    CUDA_CHECK(cudaFree(d2));

    CUDA_CHECK(cudaFreeHost(h1));
    CUDA_CHECK(cudaFreeHost(h2));

    return 0;
}
