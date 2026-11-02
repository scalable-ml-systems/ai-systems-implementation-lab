# 01-linux-to-gpu-execution

## Purpose

This case studies the complete execution path from a Linux userspace process to actual computation on an NVIDIA GPU.

The goal is not to prove that CUDA is installed or that `nvidia-smi` works.

The goal is to understand:

> **What must happen between an application requesting GPU work and the GPU executing that work?**

This case establishes the systems foundation for every later NVIDIA AI Systems case.

---

# Where This Case Fits

```text
                NVIDIA PRODUCTION AI SYSTEM

                    Application / Model
                           │
                           ▼
                    Inference Runtime
                           │
                           ▼
                    Distributed Runtime
                           │
                           ▼
                  AI Platform / Kubernetes
                           │
                           ▼
               ┌─────────────────────────┐
               │ CASE 1                  │
               │ Linux → GPU Execution   │
               │                         │
               │ CUDA / Driver / Memory  │
               │ PCIe / HBM / Kernels    │
               └─────────────────────────┘
                           │
                           ▼
                     NVIDIA GPU
```

Case 1 deliberately stays **below distributed AI, networking, Kubernetes, and inference**.

Those have their own later cases.

---

# Primary Mastery Targets

This case covers three layers of the overall mastery model.

## Layer 1 — Systems Foundation

Focus on the parts of Linux that directly participate in GPU execution:

* PCI device discovery
* kernel modules
* userspace/kernel boundary
* device files
* process/device access
* memory
* NUMA awareness
* containers
* debugging and system inspection

---

## Layer 2 — Accelerator / Hardware Systems

Understand NVIDIA GPU hardware at the level required for systems engineering:

* GPU device
* Streaming Multiprocessors
* HBM / VRAM
* memory hierarchy
* PCIe
* DMA
* host ↔ device data movement
* synchronization
* clocks / power / utilization at an operational level

This is **not** a GPU microarchitecture course.

The objective is to understand the hardware mechanisms that affect software execution and performance.

---

## Layer 3 — NVIDIA GPU Software Stack

Understand the boundaries between:

```text
Application
    ↓
CUDA Runtime
    ↓
CUDA Driver Interface
    ↓
NVIDIA Kernel Driver
    ↓
Linux
    ↓
GPU
```

Core concepts:

* NVIDIA kernel modules
* NVIDIA device nodes
* CUDA runtime
* CUDA driver
* CUDA context
* device selection
* memory allocation
* kernel launch
* streams
* synchronization
* NVIDIA Container Toolkit
* host/container driver boundary

---

# The Main Execution Path

By the end of the case, this should be one coherent mental model:

```text
Linux Process
     │
     ▼
Application
Python / C++ / PyTorch
     │
     ▼
CUDA Runtime API
     │
     ▼
CUDA Driver Interface
     │
     ▼
NVIDIA Kernel Driver
     │
     ▼
Linux Device / PCIe
     │
     ▼
NVIDIA GPU
     │
     ├── allocate device memory
     ├── receive data
     ├── schedule GPU work
     ├── execute kernels
     └── synchronize
     │
     ▼
HBM / GPU Memory
     │
     ▼
Application Result
```

The work in this repository should continuously make this diagram more concrete.

---

# Workstream 1 — Linux Discovers the GPU

## Question

> How does Linux know an NVIDIA GPU exists?

Investigate the chain:

```text
Physical GPU
    ↓
PCIe enumeration
    ↓
Linux PCI subsystem
    ↓
device identity
    ↓
NVIDIA driver binding
```

Work with:

```bash
lspci
lspci -vv
lsmod
modinfo
dmesg
```

Understand:

* PCI vendor/device IDs
* PCI bus/device/function
* PCIe link information
* kernel driver binding
* loaded NVIDIA modules

The learning objective is not command memorization.

For every command, answer:

1. **Which layer am I interrogating?**
2. **What does this result prove?**
3. **What does this result not prove?**

Example:

> `lspci` proves Linux sees the physical PCIe device. It does not prove CUDA can execute a kernel.

---

# Workstream 2 — NVIDIA Driver and Device Interface

## Question

> How does a Linux process gain access to the GPU?

Investigate:

```text
Linux process
     ↓
device interface
     ↓
NVIDIA kernel driver
     ↓
GPU
```

Study NVIDIA device nodes such as:

```text
/dev/nvidia0
/dev/nvidiactl
/dev/nvidia-uvm
```

Understand:

* character device abstraction
* kernel driver responsibilities
* userspace ↔ kernel transition
* device permissions
* Unified Virtual Memory at a conceptual level

Also inspect:

```bash
nvidia-smi
cat /proc/driver/nvidia/version
ls -l /dev/nvidia*
```

The important distinction:

```text
GPU exists
     ≠
driver works
     ≠
CUDA works
     ≠
application works
```

---

# Workstream 3 — CUDA Software Architecture

## Question

> What exists between my program and the NVIDIA driver?

Build this mental model:

```text
Application
   │
   ▼
CUDA Runtime API
   │
   ▼
CUDA Driver API
   │
   ▼
NVIDIA Driver
   │
   ▼
GPU
```

Learn:

* runtime API versus driver API
* CUDA context
* device initialization
* kernel launch
* error handling
* synchronization
* CUDA libraries versus CUDA runtime

Do not attempt to memorize the entire CUDA API.

Focus on the **execution model**.

---

# Workstream 4 — First CUDA Program

Implement a minimal CUDA workload.

Not because vector addition is impressive.

Because we need a transparent workload where every operation can be traced.

The program should expose:

```text
select GPU
    ↓
allocate host memory
    ↓
allocate device memory
    ↓
copy input → GPU
    ↓
launch kernel
    ↓
synchronize
    ↓
copy output → host
    ↓
validate result
    ↓
free resources
```

You should be able to explain every API call in terms of the system architecture.

---

# Workstream 5 — GPU Memory

This is one of the most important parts of Case 1.

## Question

> Where does data live while GPU work is executing?

Build the model:

```text
CPU
│
│ Host DRAM
│
└──────── PCIe ─────────┐
                        │
                        ▼
                     NVIDIA GPU
                        │
                        ▼
                     GPU HBM
```

Study:

* host memory
* GPU/device memory
* HBM
* allocation
* memory copies
* transfer bandwidth
* transfer latency
* DMA
* memory capacity

Understand why:

> **Moving data can be more expensive than computing on it.**

That idea will return later in networking, distributed inference, and KV-cache work.

---

# Workstream 6 — Pageable vs Pinned Host Memory

## Question

> Why does the type of CPU memory affect GPU-transfer performance?

Compare:

```text
PAGEABLE MEMORY

application buffer
      ↓
pinned staging buffer
      ↓
DMA
      ↓
GPU memory
```

with:

```text
PINNED MEMORY

application buffer
      ↓
DMA
      ↓
GPU memory
```

Experiment with:

* increasing transfer sizes
* pageable host memory
* pinned host memory
* host → device
* device → host

Measure bandwidth and latency.

Then explain **why**, not merely which one is faster.

Also understand the tradeoff:

> Why don't applications simply pin all system memory?

---

# Workstream 7 — GPU Kernel Execution

## Question

> What actually happens after a CUDA kernel is launched?

Understand enough GPU execution architecture to reason about:

```text
CPU submits kernel
       ↓
GPU receives work
       ↓
thread blocks
       ↓
Streaming Multiprocessors
       ↓
warps / threads
       ↓
instructions + memory operations
       ↓
result
```

Concepts:

* kernel
* grid
* block
* thread
* warp
* SM
* occupancy conceptually
* synchronization
* memory access

Again:

**systems understanding, not CUDA specialization.**

---

# Workstream 8 — Asynchronous Execution

This is a critical transition from conventional CPU thinking.

## Question

> Why doesn't a CUDA API call necessarily mean that GPU work has already completed?

Understand:

```text
CPU
 │
 ├── submit GPU operation
 │
 ├── continue executing
 │
 │
GPU
 └── executes independently
```

Study:

* asynchronous command submission
* synchronization
* blocking calls
* non-blocking calls
* events
* timing implications

Experiment with incorrect timing and correct GPU-aware timing.

The objective is to understand why naive CPU timing can misrepresent GPU execution.

---

# Workstream 9 — CUDA Streams

## Question

> How can independent GPU operations overlap?

Start with:

```text
STREAM 0
H2D → Kernel → D2H

STREAM 1
      H2D → Kernel → D2H
```

Understand:

* ordering within one stream
* concurrency across streams
* H2D copies
* D2H copies
* kernel overlap
* synchronization
* hardware limits on overlap

Experiment rather than assume.

Use profiling to prove what actually overlaps.

---

# Workstream 10 — Compute vs Memory vs Transfer Bottlenecks

A core diagnostic capability of Case 1.

Learn to distinguish:

```text
COMPUTE-BOUND
```

from:

```text
GPU-MEMORY-BOUND
```

from:

```text
HOST↔DEVICE-TRANSFER-BOUND
```

Create workloads deliberately biased toward each behavior.

Observe:

* execution time
* GPU utilization
* memory throughput
* transfer behavior
* profiler evidence

Then answer:

> **What resource is actually limiting this workload?**

This is the beginning of GPU performance engineering.

---

# Workstream 11 — Profiling

Profiling should answer a hypothesis.

Not produce pretty traces.

Use tools such as:

* `nvidia-smi`
* Nsight Systems
* Nsight Compute where appropriate
* CUDA timing/events

Learn to recognize:

* CPU activity
* CUDA API activity
* kernel execution
* memory copies
* synchronization
* idle gaps
* overlap
* duration

Typical question:

> Why did this workload take 25 ms?

The answer should become something like:

```text
8 ms host→device transfer
2 ms launch / synchronization overhead
11 ms GPU kernel
4 ms device→host transfer
```

Now the execution path is measurable.

---

# Workstream 12 — Containerized GPU Execution

## Question

> What changes when the CUDA workload runs inside a container?

Build the architecture:

```text
HOST
│
├── Linux kernel
├── NVIDIA kernel driver
├── GPU device nodes
└── NVIDIA Container Toolkit
        │
        ▼
CONTAINER
│
├── CUDA userspace
├── application
└── required libraries
        │
        ▼
HOST DRIVER
        │
        ▼
GPU
```

Understand:

* what belongs on the host
* what belongs in the container
* device injection
* library injection
* runtime configuration
* driver/CUDA compatibility

Important concept:

> **The container does not contain or virtualize the physical NVIDIA driver.**

It consumes the accelerator capabilities exposed by the host.

---

# Controlled Failure Exercises

This case should include failures because successful execution alone does not create systems understanding.

Use a few carefully selected failures.

## Failure 1 — GPU Exists, CUDA Does Not Work

Start from:

```text
lspci succeeds
```

but deliberately create or investigate a higher-layer failure.

Objective:

Determine which layer is broken.

---

## Failure 2 — Device Access Problem

Investigate what happens when the process cannot access the required NVIDIA device interface.

Objective:

Understand Linux/device-access boundaries.

---

## Failure 3 — Host/Container Compatibility Problem

Use or simulate a mismatched container/software configuration.

Objective:

Distinguish:

```text
container CUDA userspace
```

from:

```text
host NVIDIA driver
```

---

## Failure 4 — Performance Without Hardware Failure

Create a workload that performs poorly due to:

* unnecessary synchronization
* excessive memory transfer
* poor memory strategy

Objective:

Learn that:

> **healthy hardware does not guarantee efficient execution.**

---

# What Will Be Implemented

The repository should contain working artifacts, not extensive documentation.

A likely structure is:

```text
01-linux-to-gpu-execution/
│
├── README.md
│
├── src/
│   ├── cuda_execution_baseline/
│   ├── memory_transfer/
│   ├── async_execution/
│   ├── streams/
│   └── bottleneck_workloads/
│
├── scripts/
│   ├── inspect_host.sh
│   ├── inspect_nvidia_stack.sh
│   ├── run_memory_tests.sh
│   ├── run_stream_tests.sh
│   └── capture_profile.sh
│
├── containers/
│   └── cuda-runtime/
│
└── evidence/
```

This is a starting structure, not a requirement to create every file immediately.

Create artifacts only when they support an actual experiment.

---

# What the README Should Contain

Keep it short.

The README needs only:

1. case mission
2. location in the full NVIDIA systems architecture
3. mastery targets
4. experiment index
5. reproduction entry points
6. current status

It should **not become the textbook for the case**.

---

# What Will NOT Be Built

To preserve the boundary, Case 1 will not expand into:

* NCCL
* NVLink/NVSwitch performance analysis
* RDMA
* InfiniBand
* RoCE
* Kubernetes
* GPU scheduling
* DRA
* Kueue
* vLLM
* inference benchmarking
* distributed inference
* SLOs
* agent systems

Those topics remain visible in the flagship map, but are **locked to later cases**.

---

# Required Evidence

Only four forms of evidence matter.

## 1. Working implementation

The code and experiments execute reproducibly.

## 2. Experimental evidence

Profiles, measurements, and system output support the conclusions.

## 3. One Design Choices & Tradeoffs Document

Written after the experiments.

It should explain:

* the execution architecture
* important design decisions
* performance tradeoffs
* failure boundaries
* engineering conclusions

No tutorial prose.

## 4. Live Technical Interview

When Case 1 is complete, I interview you live.

The interview should test whether you can reason about unfamiliar variations, not whether you memorized the repository.

Examples:

> Linux sees the GPU, but CUDA initialization fails. Where do you start?

> A CUDA program is dramatically slower inside a container. What boundaries would you investigate?

> Pinned memory improves transfer throughput. What did we change physically/logically?

> Why can asynchronous CUDA code produce the wrong benchmark result?

> GPU utilization is low even though the kernel is computationally expensive. What hypotheses would you test?

That conversation is the primary mastery evidence.

---

# Definition of DONE

Case 1 is finished when you can explain and defend this system:

```text
Linux
  ↓
PCIe discovery
  ↓
NVIDIA driver
  ↓
device interfaces
  ↓
CUDA userspace
  ↓
memory allocation
  ↓
host/device movement
  ↓
command submission
  ↓
GPU kernel execution
  ↓
synchronization
  ↓
result
```

And reason backward from symptoms:

```text
application problem
       ↓
CUDA API?
       ↓
memory?
       ↓
synchronization?
       ↓
driver?
       ↓
device access?
       ↓
PCIe / hardware?
```

At that point:

**live interview → one design/tradeoffs document → Case 1 DONE.**

Then and only then do we unlock:

# Case 2 — AI Networking & Fabric

