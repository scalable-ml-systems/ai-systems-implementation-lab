#include <cuda_runtime.h>

#include <cstdio>

__device__ __forceinline__ unsigned int get_smid() {
    unsigned int smid;

    asm(
        "mov.u32 %0, %%smid;"
        : "=r"(smid)
    );

    return smid;
}

__global__ void show_block_location() {
    if (threadIdx.x == 0) {
        printf(
            "block=%d sm=%u\n",
            blockIdx.x,
            get_smid()
        );
    }
}

int main() {
    show_block_location<<<64, 256>>>();

    cudaDeviceSynchronize();

    return 0;
}
