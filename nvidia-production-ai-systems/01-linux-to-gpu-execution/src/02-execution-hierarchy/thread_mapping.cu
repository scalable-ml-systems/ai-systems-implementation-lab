#include <cuda_runtime.h>

#include <iostream>

__global__ void show_threads() {
    int global_id =
        blockIdx.x * blockDim.x + threadIdx.x;

    printf(
        "block=%d thread=%d global=%d\n",
        blockIdx.x,
        threadIdx.x,
        global_id
    );
}

int main() {
    show_threads<<<3, 8>>>();

    cudaDeviceSynchronize();

    return 0;
}
