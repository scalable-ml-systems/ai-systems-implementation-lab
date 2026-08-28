# Nsight Systems Report — Host↔Device Transfer-Bound Workload

## Objective

Validate the hypothesis that the workload is limited by host↔device data movement over PCIe rather than GPU computation.

## Hypothesis

```text
CPU DRAM
   ↓
H2D transfer
   ↓
Tiny GPU kernel
   ↓
D2H transfer
```

### Expected Behavior

H2D and D2H transfer time should dominate, while kernel execution should be negligible.

## Nsight Systems Results

### GPU Memory Operations

| Operation | Total time | Count | Average time | Share of GPU memory operations |
|---|---:|---:|---:|---:|
| Device → Host | 5.672 s | 202 | 28.08 ms | 54.1% |
| Host → Device | 4.803 s | 202 | 23.78 ms | 45.9% |
| CUDA memset | 0.251 ms | 1 | 0.251 ms | ~0% |

Each H2D and D2H operation transferred approximately **268.435 MB**.

### GPU Kernel Execution

| Kernel | Total time | Instances | Average time |
|---|---:|---:|---:|
| `tiny_kernel(int*)` | 0.227 ms | 202 | 0.001125 ms |

This is the strongest evidence in the profile:

```text
H2D    ≈ 23.8 ms
Kernel ≈ 0.0011 ms
D2H    ≈ 28.1 ms
```

The kernel is effectively insignificant compared with the transfer cost.

### CUDA API Activity

| CUDA API | Total time | Calls | Average time | API time share |
|---|---:|---:|---:|---:|
| `cudaMemcpyAsync` | 6.373 s | 404 | 15.77 ms | 59.1% |
| `cudaEventSynchronize` | 4.093 s | 200 | 20.47 ms | 38.0% |
| `cudaMallocHost` | 238.34 ms | 1 | 238.34 ms | 2.2% |
| `cudaLaunchKernel` | 2.83 ms | 202 | 0.014 ms | ~0% |

## Diagnosis

### Where Is the Bottleneck?

```text
Host DRAM ↔ PCIe ↔ GPU HBM
```

The bottleneck is the host↔device transfer path.

### Why?

The workload transfers approximately **268 MB into the GPU** and **268 MB back to the host** during every iteration, while performing almost no GPU computation.

Nsight Systems confirms:

```text
Data movement >>> Kernel execution
```

The workload is therefore **host↔device-transfer-bound**.

The significant time attributed to `cudaEventSynchronize()` should not be interpreted as synchronization logic itself being expensive. It represents the CPU waiting for previously submitted GPU operations to complete.

## Appropriate Optimization Direction

Because the kernel is not the bottleneck, optimizing it would have virtually no meaningful effect.

The appropriate interventions focus on reducing or hiding host↔device transfer cost:

```text
Reduce H2D/D2H transfers
        ↓
Keep data resident on the GPU longer
        ↓
Batch transfers where possible
        ↓
Use pinned host memory
        ↓
Overlap transfers with useful work when possible
```

### Recommended Next Experiments

- Keep intermediate data on the GPU across multiple kernel launches
- Replace per-iteration H2D/D2H copies with batched transfers
- Use pinned host buffers for DMA-capable staging
- Use `cudaMemcpyAsync()` with CUDA streams
- Implement double-buffering to overlap H2D transfer, kernel execution, and D2H transfer
- Compare sequential execution with a multi-stream pipelined implementation
