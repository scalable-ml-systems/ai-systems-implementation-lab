# Compute-Bound Profiling Report — Arithmetic Intensity

## Objective

The goal was to confirm whether the `compute_bound` CUDA workload was limited by:

* GPU memory bandwidth, or
* GPU compute resources.

The workload was intentionally designed to perform **a lot of math on each value after loading it from memory**.

---

## Arithmetic Intensity

Arithmetic Intensity means:

> **How much useful math does the GPU perform for the amount of data it has to move?**

In simple terms:

```text
Low Arithmetic Intensity
→ move lots of data
→ do little math

High Arithmetic Intensity
→ move relatively little data
→ do lots of math
```

The compute-bound kernel followed this pattern:

```text
Load value from GPU memory
        ↓
perform many arithmetic operations
        ↓
reuse the same value repeatedly
        ↓
write result back to GPU memory
```

Because the value is reused many times before being written back, the kernel performs a large amount of computation compared with the amount of memory traffic.

This gives the workload **high arithmetic intensity**.

---

## Nsight Compute Results

| Metric                  |      Result |
| ----------------------- | ----------: |
| Compute (SM) Throughput |  **99.71%** |
| DRAM Throughput         |   **8.38%** |
| Kernel Duration         | **2.84 ms** |
| SM Frequency            |    2.55 GHz |

The most important comparison is:

```text
Compute throughput    99.71%   ← almost saturated
DRAM throughput        8.38%   ← lightly used
```

---

## Diagnosis

The workload is **compute-bound**.

The GPU's compute resources are almost fully utilized, while GPU memory bandwidth is far from saturated.

```text
GPU HBM
  │
  │ small amount of traffic
  ▼
SM
  │
  │ lots of arithmetic
  ▼
Compute resources   ← bottleneck
```

The GPU is not waiting for data.

It is busy doing math.

---

## Connection to Arithmetic Intensity

This result shows why Arithmetic Intensity is useful.

Our memory-bound vector-add workload had very low arithmetic intensity:

```text
read A
read B
write C
   ↓
only one addition
```

Nsight Compute showed approximately:

```text
DRAM throughput      ~95%
Compute throughput    ~6%
```

The memory system was almost saturated while the compute resources were lightly used.

The compute-heavy workload did the opposite:

```text
Load once
   ↓
perform many calculations
   ↓
reuse data
   ↓
store once
```

Its profile showed:

```text
DRAM throughput        8.38%
Compute throughput    99.71%
```

---

## Side-by-Side Comparison

| Workload             | Arithmetic Intensity | DRAM Throughput | Compute Throughput | Bottleneck  |
| -------------------- | -------------------- | --------------: | -----------------: | ----------- |
| Vector Add           | Very low             |            ~95% |                ~6% | GPU memory  |
| Compute-heavy kernel | High                 |             ~8% |              ~100% | GPU compute |

This gives a simple mental model:

```text
LOW Arithmetic Intensity

Data movement >>> Math
        ↓
HBM becomes busy
        ↓
MEMORY-BOUND
```

```text
HIGH Arithmetic Intensity

Math >>> Data movement
        ↓
SM compute becomes busy
        ↓
COMPUTE-BOUND
```

---

## Key Lesson

Arithmetic Intensity helps answer:

> **Is the GPU spending most of its effort moving data or performing math?**

If the workload performs little computation for every byte moved, memory bandwidth is more likely to limit performance.

If the workload reuses data and performs lots of computation for every byte moved, compute resources are more likely to become the limit.

The profiler results demonstrated both cases experimentally.

---

## Summary

> I used Arithmetic Intensity to predict whether a workload would be memory-bound or compute-bound. A vector-add kernel had very low arithmetic intensity and Nsight Compute showed about 95% DRAM throughput but only about 6% compute utilization. I then created a high-arithmetic-intensity workload by loading values once and performing many calculations before writing them back. Nsight Compute showed about 99.7% compute throughput and only 8.4% DRAM throughput. That confirmed that increasing useful computation per byte moved shifted the bottleneck from GPU memory bandwidth to GPU compute.
