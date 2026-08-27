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

__global__ void compute_heavy(float* x, size_t n, int iters) {
    size_t i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i >= n) return;

    float v = x[i];

    #pragma unroll 4
    for (int j = 0; j < iters; ++j) {
        v = v * 1.000001f + 0.000001f;
    }

    x[i] = v;
}

int main() {
    const size_t n = 32ULL * 1024 * 1024;
    const size_t bytes = n * sizeof(float);

    float* d_x = nullptr;
    CUDA_CHECK(cudaMalloc(&d_x, bytes));
    CUDA_CHECK(cudaMemset(d_x, 0, bytes));

    const int threads = 256;
    const int blocks = (n + threads - 1) / threads;

    const int iters = 1000;

    // warm-up
    compute_heavy<<<blocks, threads>>>(d_x, n, 10);
    CUDA_CHECK(cudaDeviceSynchronize());

    cudaEvent_t start, stop;
    CUDA_CHECK(cudaEventCreate(&start));
    CUDA_CHECK(cudaEventCreate(&stop));

    CUDA_CHECK(cudaEventRecord(start));

    compute_heavy<<<blocks, threads>>>(d_x, n, iters);

    CUDA_CHECK(cudaEventRecord(stop));
    CUDA_CHECK(cudaEventSynchronize(stop));

    float ms = 0.0f;
    CUDA_CHECK(cudaEventElapsedTime(&ms, start, stop));

    // 1 multiply + 1 add per iteration
    double flops =
        static_cast<double>(n) *
        iters *
        2.0;

    double tflops =
        flops / (ms / 1000.0) / 1e12;

    std::cout << "Kernel time: "
              << ms << " ms\n";

    std::cout << "Approx FP32 throughput: "
              << tflops << " TFLOP/s\n";

    CUDA_CHECK(cudaEventDestroy(start));
    CUDA_CHECK(cudaEventDestroy(stop));
    CUDA_CHECK(cudaFree(d_x));

    return 0;
}
