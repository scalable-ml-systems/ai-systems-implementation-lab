#include <cuda_runtime.h>

#include <cstdio>

__device__ __forceinline__ unsigned int get_lane_id() {
    unsigned int lane;

    asm(
        "mov.u32 %0, %%laneid;"
        : "=r"(lane)
    );

    return lane;
}

__global__ void show_warps() {
    const int tid = threadIdx.x;
    const int logical_warp = tid / warpSize;
    const unsigned int lane = get_lane_id();

    printf(
        "block=%d thread=%d "
        "warp=%d lane=%u\n",
        blockIdx.x,
        tid,
        logical_warp,
        lane
    );
}

int main() {
    show_warps<<<1, 64>>>();

    cudaDeviceSynchronize();

    return 0;
}
