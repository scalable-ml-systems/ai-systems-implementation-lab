Case 01 — Linux to NVIDIA GPU Execution
Mission
Understand and experimentally prove the execution path from a Linux userspace process to computation executing on an NVIDIA GPU.

The goal is not to verify that CUDA is installed. The goal is to understand the responsibility boundaries between:

text


## Reference Path Execution 

Linux Process
    │
    ▼
Application
Python / C++ / CUDA
    │
    ▼
CUDA Userspace Runtime / Libraries
    │
    ▼
NVIDIA Driver Interface
Userspace ↔ Kernel Boundary
    │
    ▼
NVIDIA Kernel Driver
    │
    ▼
Linux Device / PCIe
    │
    ▼
NVIDIA GPU
    ├── Device memory allocation
    ├── Command submission
    ├── Kernel execution
    └── Synchronization
    │
    ▼
GPU HBM / VRAM
    │
    ▼
Application Result


Mastery Targets
1. Systems Foundation
Understand how Linux discovers, exposes, and provides process access to an NVIDIA GPU.

2. Accelerator Systems
Understand the GPU, PCIe, host/device memory, HBM, DMA, execution, and synchronization mechanisms required to reason about GPU workloads.

3. NVIDIA GPU Software Stack
Understand the boundaries between the NVIDIA kernel driver, CUDA userspace, the CUDA execution model, and the physical accelerator.

Scope Boundary
In Scope
Linux PCI device discovery

NVIDIA kernel driver

NVIDIA device interfaces

CUDA runtime and driver relationship

CUDA context and device selection

Host and device memory

HBM / VRAM

PCIe data movement

Pageable and pinned memory

Kernel execution

Asynchronous execution

Synchronization

CUDA streams

Compute vs. memory vs. transfer bottlenecks

Basic NVIDIA profiling

NVIDIA Container Toolkit

Host/container GPU boundary

Explicitly Out of Scope
NCCL deep dive

NVLink / NVSwitch performance analysis

RDMA

InfiniBand

RoCE

Multi-node execution

Tensor parallelism

Kubernetes scheduling

Kueue

Dynamic Resource Allocation (DRA)

vLLM

Inference performance

Production SLOs

Agent systems
