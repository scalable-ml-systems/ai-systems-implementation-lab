#include <cuda_runtime.h>

#include <cmath>
#include <cstdlib>
#include <iostream>

#define CUDA_CHECK(call)                                                   \
    do {                                                                   \
        cudaError_t error = (call);                                        \
        if (error != cudaSuccess) {                                        \
            std::cerr << "CUDA error at " << __FILE__ << ":" << __LINE__  \
                      << ": " << cudaGetErrorString(error) << '\n';       \
            std::exit(EXIT_FAILURE);                                      \
        }                                                                  \
    } while (0)

__global__ void vector_add(
    const float* a,
    const float* b,
    float* c,
    int n
) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    // Discover CUDA-visible GPUs.
    int device_count = 0;
    CUDA_CHECK(cudaGetDeviceCount(&device_count));

    std::cout
        << "CUDA devices visible: "
        << device_count
        << '\n';

    if (device_count == 0) {
        std::cerr << "No CUDA-capable GPU is visible.\n";
        return EXIT_FAILURE;
    }

    // Select GPU 0 and print its properties.
    const int device = 0;
    CUDA_CHECK(cudaSetDevice(device));

    cudaDeviceProp props{};
    CUDA_CHECK(cudaGetDeviceProperties(&props, device));

    std::cout
        << "Using GPU: "
        << props.name
        << '\n';

    const int n = 1 << 20;
    const size_t bytes = n * sizeof(float);

    // Allocate host (CPU) memory.
    float* h_a = new float[n];
    float* h_b = new float[n];
    float* h_c = new float[n];

    // Initialize input vectors in host RAM.
    for (int i = 0; i < n; ++i) {
        h_a[i] = 1.0f;
        h_b[i] = 2.0f;
    }

    // Device (GPU) pointers.
    float* d_a = nullptr;
    float* d_b = nullptr;
    float* d_c = nullptr;

    // Allocate device memory in GPU HBM / VRAM.
    CUDA_CHECK(cudaMalloc(&d_a, bytes));
    CUDA_CHECK(cudaMalloc(&d_b, bytes));
    CUDA_CHECK(cudaMalloc(&d_c, bytes));

    // Copy input arrays from host RAM to GPU memory.
    CUDA_CHECK(cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice));

    // Define the CUDA grid.
    const int threads_per_block = 256;
    const int blocks = (n + threads_per_block - 1) / threads_per_block;

    // Launch one GPU thread per vector element.
    vector_add<<<blocks, threads_per_block>>>(d_a, d_b, d_c, n);

    // Check launch configuration/launch errors immediately.
    CUDA_CHECK(cudaGetLastError());

    // Wait for GPU execution and catch asynchronous execution errors.
    CUDA_CHECK(cudaDeviceSynchronize());

    // Copy computed result from device memory to host RAM.
    CUDA_CHECK(cudaMemcpy(
        h_c,
        d_c,
        bytes,
        cudaMemcpyDeviceToHost
    ));

    // Verify c[i] == a[i] + b[i] == 3.0.
    bool valid = true;

    for (int i = 0; i < n; ++i) {
        if (std::fabs(h_c[i] - 3.0f) > 1e-5f) {
            valid = false;
            break;
        }
    }

    std::cout
        << "Result: "
        << (valid ? "PASS" : "FAIL")
        << '\n';

    // Release device memory.
    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));

    // Release host memory.
    delete[] h_a;
    delete[] h_b;
    delete[] h_c;

    return valid ? EXIT_SUCCESS : EXIT_FAILURE;
}
