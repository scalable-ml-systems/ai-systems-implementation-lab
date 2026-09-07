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

double ms_between(Clock::time_point a, Clock::time_point b) {
    return std::chrono::duration<double, std::milli>(b - a).count();
}

int main() {
    const size_t bytes = 256ULL * 1024 * 1024;

    // Pageable host memory
    void* h_pageable = std::malloc(bytes);

    // Pinned host memory
    void* h_pinned = nullptr;
    CUDA_CHECK(cudaMallocHost(&h_pinned, bytes));

    // GPU memory
    void* d_buffer = nullptr;
    CUDA_CHECK(cudaMalloc(&d_buffer, bytes));

    cudaStream_t stream;
    CUDA_CHECK(cudaStreamCreate(&stream));

    // Warm up CUDA so initialization doesn't pollute measurement
    CUDA_CHECK(cudaFree(0));

    // -------------------------
    // Pageable async copy
    // -------------------------

    auto p_start = Clock::now();

    CUDA_CHECK(cudaMemcpyAsync(
        d_buffer,
        h_pageable,
        bytes,
        cudaMemcpyHostToDevice,
        stream
    ));

    auto p_return = Clock::now();

    CUDA_CHECK(cudaStreamSynchronize(stream));

    auto p_done = Clock::now();

    // -------------------------
    // Pinned async copy
    // -------------------------

    auto pin_start = Clock::now();

    CUDA_CHECK(cudaMemcpyAsync(
        d_buffer,
        h_pinned,
        bytes,
        cudaMemcpyHostToDevice,
        stream
    ));

    auto pin_return = Clock::now();

    CUDA_CHECK(cudaStreamSynchronize(stream));

    auto pin_done = Clock::now();

    std::cout << "Pageable:\n";
    std::cout << "  API return time: "
              << ms_between(p_start, p_return)
              << " ms\n";
    std::cout << "  Total completion: "
              << ms_between(p_start, p_done)
              << " ms\n\n";

    std::cout << "Pinned:\n";
    std::cout << "  API return time: "
              << ms_between(pin_start, pin_return)
              << " ms\n";
    std::cout << "  Total completion: "
              << ms_between(pin_start, pin_done)
              << " ms\n";

    CUDA_CHECK(cudaStreamDestroy(stream));
    CUDA_CHECK(cudaFree(d_buffer));
    CUDA_CHECK(cudaFreeHost(h_pinned));
    std::free(h_pageable);

    return 0;
}
