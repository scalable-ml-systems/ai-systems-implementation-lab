# GPU Profiling Brief

## Objective

Profiling should answer a **performance hypothesis**, not simply generate traces.

The core question is:

> **Where did the execution time go, and what resource limited performance?**

The workflow is:

```text
Hypothesis
   ↓
Measure
   ↓
Profile
   ↓
Identify dominant resource
   ↓
Explain WHY
   ↓
Make one targeted change
   ↓
Measure again
```

---

## Profiling Tools

### `nvidia-smi`

Provides coarse GPU state:

* GPU utilization
* GPU memory usage
* clocks
* power
* temperature
* active processes

Use it for general system observation, not detailed kernel diagnosis.

---

### Nsight Systems

Answers:

> **WHERE did the time go?**

Look for:

* CUDA API calls
* H2D and D2H memory copies
* kernel execution
* synchronization
* CPU/GPU idle gaps
* concurrency and overlap

Example:

```text
H2D        8 ms
Kernel    11 ms
D2H        4 ms
Sync       2 ms
----------------
Total     25 ms
```

The largest components tell us where to investigate.

---

### Nsight Compute

Answers:

> **WHY is this GPU kernel limited?**

Start with only a few important metrics:

| Metric                   | Question                                         |
| ------------------------ | ------------------------------------------------ |
| DRAM / Memory Throughput | Is GPU memory bandwidth saturated?               |
| Compute (SM) Throughput  | Are GPU compute units heavily utilized?          |
| Kernel Duration          | How long does the kernel execute?                |
| Occupancy                | Are enough warps available to keep the GPU busy? |

Do not try to optimize every metric or warning. Focus on the resource actually limiting performance.

---

# Experiment Results

## 1. Host↔Device Transfer-Bound Workload

Nsight Systems showed approximately:

| Activity   | Average Time |
| ---------- | -----------: |
| H2D copy   |      23.8 ms |
| GPU kernel |    0.0011 ms |
| D2H copy   |      28.1 ms |

Each transfer moved approximately 268 MB.

### Diagnosis

```text
CPU DRAM
   ↕
PCIe          ← bottleneck
   ↕
GPU HBM
```

The kernel was effectively insignificant compared with the memory-transfer time.

**Conclusion:** the workload was **host↔device-transfer-bound**.

Appropriate improvements include:

* reducing H2D/D2H transfers
* keeping data GPU-resident longer
* batching transfers
* using pinned memory
* overlapping transfers with useful work

---

## 2. GPU-Memory-Bound Workload

Nsight Systems first showed that the `vector_add` kernel dominated GPU execution and that there were no H2D/D2H transfers in the measured workload.

Nsight Compute then showed:

| Metric                |  Result |
| --------------------- | ------: |
| DRAM throughput       |  ~95.2% |
| Compute/SM throughput |   ~6.4% |
| Kernel duration       | ~820 μs |
| Achieved occupancy    |    ~86% |

The profiler showed DRAM throughput near saturation while compute utilization remained very low.

Achieved occupancy was already approximately 86%, so occupancy was not the primary limitation.

### Diagnosis

```text
GPU HBM
   ↕
Memory bandwidth    ← bottleneck
   ↕
SMs
```

Vector addition has very low arithmetic intensity:

```text
read A
read B
write C

≈ 12 bytes moved
for
1 floating-point addition
```

**Conclusion:** the kernel was **GPU-memory-bandwidth-bound**.

---

# How to Read Profiling Reports

Use this simple decision process:

```text
Nsight Systems
      ↓
WHERE is time spent?

Large H2D/D2H
→ Transfer-bound

Kernel dominates
      ↓
Nsight Compute
      ↓
WHAT resource is saturated?

High DRAM + low compute
→ GPU-memory-bound

High compute + lower DRAM
→ Compute-bound

Large waits / idle gaps
→ synchronization or orchestration problem
```

## Key Mental Model

> **Nsight Systems tells me WHERE the time went.
> Nsight Compute tells me WHY a kernel behaved that way.**

The goal of profiling is not to collect metrics.

The goal is to produce a causal explanation of performance.

