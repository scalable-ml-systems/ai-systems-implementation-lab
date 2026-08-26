#include <cuda_runtime.h>

#include <cstdlib>
#include <iostream>

#define CUDA_CHECK(call)                                                   \
    do {                                                                   \
        cudaError_t error = (call);                                        \
        if (error != cudaSuccess) {                                        \
            std::cerr                                                     \
                << cudaGetErrorString(error)                               \
                << '\n';                                                   \
            std::exit(EXIT_FAILURE);                                      \
        }                                                                  \
    } while (0)

int main() {
    const int device = 0;

    CUDA_CHECK(cudaSetDevice(device));

    cudaDeviceProp props{};

    CUDA_CHECK(
        cudaGetDeviceProperties(&props, device)
    );

    std::cout
        << "GPU: "
        << props.name
        << '\n';

    std::cout
        << "Compute capability: "
        << props.major
        << "."
        << props.minor
        << '\n';

    std::cout
        << "Streaming Multiprocessors: "
        << props.multiProcessorCount
        << '\n';

    std::cout
        << "Warp size: "
        << props.warpSize
        << '\n';

    std::cout
        << "Max threads per block: "
        << props.maxThreadsPerBlock
        << '\n';

    std::cout
        << "Max threads per SM: "
        << props.maxThreadsPerMultiProcessor
        << '\n';

    return 0;
}
