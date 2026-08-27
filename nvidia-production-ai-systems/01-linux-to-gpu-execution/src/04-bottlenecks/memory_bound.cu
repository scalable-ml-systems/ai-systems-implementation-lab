#include <cuda_runtime.h>
#include <cstdlib>
#include <iostream>

#define CUDA_CHECK(call)                                  \
do {                                                      \
    cudaError_t e = (call);                               \
    if (e != cudaSuccess) {                               \
        std::cerr << cudaGetErrorString(e) << "\n";       \
        std::exit(EXIT_FAILURE);                          \
    }                                                     \
} while (0)

__global__ void vector_add(
    const float* a,
    const float* b,
    float* c,
    size_t n
) {
    size_t i =
        blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n)
        c[i] = a[i] + b[i];
}

int main() {
    // 256 MB per array
    const size_t bytes = 256ULL * 1024 * 1024;
    const size_t n = bytes / sizeof(float);

    float *a, *b, *c;

    CUDA_CHECK(cudaMalloc(&a, bytes));
    CUDA_CHECK(cudaMalloc(&b, bytes));
    CUDA_CHECK(cudaMalloc(&c, bytes));

    CUDA_CHECK(cudaMemset(a, 1, bytes));
    CUDA_CHECK(cudaMemset(b, 2, bytes));

    const int threads = 256;
    const int blocks =
        (n + threads - 1) / threads;

    // Warm-up
    vector_add<<<blocks, threads>>>(a, b, c, n);
    CUDA_CHECK(cudaDeviceSynchronize());

    cudaEvent_t start, stop;
    CUDA_CHECK(cudaEventCreate(&start));
    CUDA_CHECK(cudaEventCreate(&stop));

    const int iterations = 20;

    CUDA_CHECK(cudaEventRecord(start));

    for (int i = 0; i < iterations; ++i)
        vector_add<<<blocks, threads>>>(a, b, c, n);

    CUDA_CHECK(cudaEventRecord(stop));
    CUDA_CHECK(cudaEventSynchronize(stop));

    float total_ms;
    CUDA_CHECK(cudaEventElapsedTime(
        &total_ms, start, stop));

    const double kernel_ms =
        total_ms / iterations;

    // A read + B read + C write
    const double bytes_per_kernel =
        3.0 * bytes;

    const double bandwidth_gbps =
        (bytes_per_kernel / 1e9) /
        (kernel_ms / 1000.0);

    std::cout
        << "Kernel time: "
        << kernel_ms
        << " ms\n";

    std::cout
        << "Effective HBM bandwidth: "
        << bandwidth_gbps
        << " GB/s\n";

    std::cout
        << "Arithmetic intensity: ~0.083 FLOP/byte\n";

    CUDA_CHECK(cudaFree(a));
    CUDA_CHECK(cudaFree(b));
    CUDA_CHECK(cudaFree(c));

    CUDA_CHECK(cudaEventDestroy(start));
    CUDA_CHECK(cudaEventDestroy(stop));
}
