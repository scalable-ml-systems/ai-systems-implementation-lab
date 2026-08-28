# Nsight Systems Report — GPU Memory-Bound Vector Addition

## Objective

Profile a GPU-resident vector-addition workload and determine whether the limiting factor is:

- Host↔device transfer over PCIe
- GPU arithmetic throughput
- GPU HBM memory bandwidth

## Workload

The profiled kernel performs element-wise vector addition:

```cpp
c[i] = a[i] + b[i];
```

For each element, the kernel approximately performs:

```text
Memory traffic:
- Read a[i]: 4 bytes
- Read b[i]: 4 bytes
- Write c[i]: 4 bytes

Total: 12 bytes

Compute:
- One floating-point addition

Total: 1 FLOP
```

The approximate arithmetic intensity is therefore:

\[
\frac{1\ \text{FLOP}}{12\ \text{bytes}}
\approx 0.083\ \text{FLOP/byte}
\]

This is very low arithmetic intensity, which strongly suggests that vector addition is limited by GPU memory bandwidth rather than floating-point compute throughput.

## Nsight Systems Results

### CUDA API Summary

| CUDA API | Total time | Calls | Average time | API time share |
|---|---:|---:|---:|---:|
| `cudaMalloc` | 112.894 ms | 3 | 37.631 ms | 83.5% |
| `cudaEventSynchronize` | 17.176 ms | 1 | 17.176 ms | 12.7% |
| `cudaFree` | 3.537 ms | 3 | 1.179 ms | 2.6% |
| `cudaDeviceSynchronize` | 0.872 ms | 1 | 0.872 ms | 0.6% |
| `cudaLaunchKernel` | 0.674 ms | 21 | 0.032 ms | 0.5% |
| `cudaMemset` | 0.038 ms | 2 | 0.006 ms | ~0% |

### Interpretation of CUDA API Time

The large `cudaMalloc` time is one-time setup overhead, not the steady-state bottleneck in the vector-addition workload.

Similarly, the `cudaEventSynchronize` time should not be interpreted as expensive synchronization logic. It represents the CPU waiting for previously enqueued GPU work to complete.

For steady-state execution, the important result is the GPU kernel summary.

## GPU Kernel Summary

| Kernel | Total GPU time | Instances | Average time | Median time |
|---|---:|---:|---:|---:|
| `vector_add(const float*, const float*, float*, unsigned long)` | 18.138 ms | 21 | 0.864 ms | 0.863 ms |

The kernel duration is highly consistent across runs:

```text
Minimum: 0.861 ms
Maximum: 0.872 ms
Standard deviation: 0.002 ms
```

This low variation indicates stable kernel execution behavior during profiling.

## GPU Memory Operations

| Operation | Total size | Count | Average size |
|---|---:|---:|---:|
| CUDA memset | 536.871 MB | 2 | 268.435 MB |

| Operation | Total GPU time | Count | Average time |
|---|---:|---:|---:|
| CUDA memset | 0.532 ms | 2 | 0.266 ms |

No H2D or D2H transfer operations appear in the profile.

This confirms that the vector data is already resident in GPU memory during the measured kernel loop. The workload is therefore **not PCIe-bound**.

## Diagnosis

### Where Is the Bottleneck?

```text
GPU HBM
   ↓
GPU memory subsystem
   ↓
Streaming Multiprocessors
```

The bottleneck is inside the GPU memory path.

The data is already on the GPU, so PCIe host↔device transfer is not on the critical path.

### Why Is It Memory-Bound?

Vector addition performs very little computation per byte transferred:

```text
12 bytes moved
for
1 FLOP
```

\[
\text{Arithmetic intensity} \approx 0.083\ \text{FLOP/byte}
\]

The kernel must repeatedly fetch input values from HBM and write output values back to HBM, while performing only one addition per element.

The measured effective bandwidth of approximately **933 GB/s** is consistent with a workload that is primarily constrained by the GPU memory subsystem.

```text
HBM traffic >>> arithmetic work
```

## Important Profiling Note

Nsight Systems establishes that:

- The workload is GPU-resident during kernel execution.
- No H2D or D2H transfers dominate the measured loop.
- `vector_add` accounts for the GPU execution time.
- Kernel timings are stable across 21 executions.

However, Nsight Systems does not by itself provide the detailed hardware throughput metrics needed to conclusively prove HBM saturation. Use **Nsight Compute** to validate achieved memory throughput, percentage of peak HBM bandwidth, memory-load efficiency, memory-store efficiency, occupancy, and warp-stall reasons.

## Optimization Direction

Because this kernel has low arithmetic intensity, the most useful optimizations reduce global-memory traffic or improve data reuse:

- Fuse compatible element-wise kernels to avoid writing intermediate tensors to HBM and reading them back.
- Reuse values from registers, shared memory, or cache when the algorithm permits.
- Ensure adjacent threads access adjacent addresses for coalesced global-memory loads and stores.
- Use lower-precision data types where numerical requirements permit.
- Reduce unnecessary reads, writes, or intermediate buffers.
- Increase useful computation per byte transferred when algorithmically appropriate.

For a standalone vector addition, optimization headroom is inherently limited because each output element must read two values and write one value. Kernel fusion is usually the highest-value optimization in real ML pipelines.
