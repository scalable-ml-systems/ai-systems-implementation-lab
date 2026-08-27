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

__global__ void delay_kernel(unsigned long long cycles) {
    unsigned long long start = clock64();

    while (clock64() - start < cycles) {
        // deliberately keep GPU busy
    }
}

double ms(Clock::time_point a, Clock::time_point b) {
    return std::chrono::duration<double, std::milli>(b - a).count();
}

int main() {
    cudaDeviceProp props{};
    CUDA_CHECK(cudaGetDeviceProperties(&props, 0));

    // approximately 500 ms worth of GPU clock cycles
    unsigned long long cycles =
        static_cast<unsigned long long>(
            props.clockRate * 1000ULL / 2
        );
      
    // Warm up CUDA
    CUDA_CHECK(cudaFree(0));

    delay_kernel<<<1, 1>>>(1000);
    CUDA_CHECK(cudaDeviceSynchronize());

    auto start = Clock::now();

    delay_kernel<<<1, 1>>>(cycles);

    CUDA_CHECK(cudaGetLastError());

    auto launch_returned = Clock::now();

    CUDA_CHECK(cudaDeviceSynchronize());

    auto completed = Clock::now();

    std::cout
        << "Kernel launch API return: "
        << ms(start, launch_returned)
        << " ms\n";

    std::cout
        << "GPU completion: "
        << ms(start, completed)
        << " ms\n";

    return 0;
}
