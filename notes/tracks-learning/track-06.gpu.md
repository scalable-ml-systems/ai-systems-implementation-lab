# Track 06 — GPU and LLM Inference Systems

## Purpose

Track 06 develops practical fluency in GPU-backed LLM inference through small, controlled experiments.

Each micro-build isolates one important inference mechanism, measures its behavior, and documents when the technique improves or degrades performance.

This track supports:

* AI infrastructure interviews;
* inference-system design fluency;
* GPU performance understanding;
* stronger decisions inside the ROCm flagship;
* evidence-backed Stackbytes writing.

Track 06 is not a separate flagship project.

---

## Core Thesis

LLM inference optimization is shifting from isolated model and kernel techniques toward workload-aware systems engineering across:

* GPU memory;
* KV-cache management;
* scheduling;
* batching;
* decoding;
* routing;
* parallelism;
* distributed execution.

An optimization is useful only when its benefit is demonstrated under a defined workload and evaluated against its operational trade-offs.

---

## Scope

Track 06 will contain small benchmark-oriented micro-builds covering the following areas.

### 1. Inference Fundamentals

* model-weight memory;
* KV-cache memory;
* prefill versus decode;
* time to first token;
* time per output token;
* latency versus throughput;
* batching and queueing;
* GPU utilization and saturation.

### 2. Core Optimization Experiments

Initial experiments may include:

* KV caching;
* continuous batching;
* weight quantization;
* prefix caching;
* speculative decoding;
* chunked prefill;
* KV-cache quantization;
* CUDA Graph or HIP Graph execution;
* optimized attention kernels.

### 3. Advanced Experiments

Implemented only when time and hardware permit:

* hierarchical KV-cache offloading;
* cache-aware request routing;
* asynchronous scheduling;
* context parallelism;
* expert parallelism;
* EAGLE or multi-token prediction;
* prefill–decode disaggregation.

### 4. Frontier Watchlist

Research-stage techniques may be explored through simulations, reduced reproductions, or paper reviews:

* dynamic KV-cache eviction;
* sparse KV attention;
* adaptive speculative decoding;
* selective KV transfer;
* compressed-cache drafting with full-cache verification;
* SLO-aware inference optimization controllers.

Frontier topics are not automatically implementation commitments.

---

## Micro-Build Method

Every experiment follows the same workflow:

```text
Understand the bottleneck
        ↓
Draw the mechanism
        ↓
Define the hypothesis
        ↓
Establish the baseline
        ↓
Enable or implement the optimization
        ↓
Run the same controlled workload
        ↓
Compare before and after
        ↓
Explain the causal result
```

Each experiment must answer:

1. What bottleneck does the technique address?
2. Where does it operate in the inference stack?
3. What changed between baseline and optimized runs?
4. Which workload conditions were held constant?
5. What performance metric improved?
6. What trade-off was introduced?
7. When would the technique not help?

---

## Benchmark Requirements

Every measured run must record:

### Hardware

* GPU model and count;
* GPU memory;
* CPU and system memory;
* interconnect and topology where relevant.

### Software

* operating system;
* driver;
* CUDA or ROCm version;
* PyTorch version;
* inference runtime and version;
* model name and revision.

### Workload

* prompt dataset;
* input-token distribution;
* output-token distribution;
* request count;
* concurrency;
* request rate;
* sampling configuration;
* cache state.

### Execution

* warm-up runs;
* measured runs;
* random seed;
* timeout;
* failed request count;
* out-of-memory count.

---

## Standard Metrics

Experiments should collect the relevant subset of:

* TTFT p50 and p95;
* TPOT or inter-token latency p50 and p95;
* end-to-end latency;
* requests per second;
* output tokens per second;
* peak GPU memory;
* GPU utilization;
* queue time;
* cache-hit rate;
* speculative acceptance rate;
* error and OOM count;
* quality or output-equivalence score.

Average latency alone is not sufficient.

---

## Standard Deliverables

Each micro-build should contain:

```text
README.md
SYSTEM-DIAGRAM.md
BENCHMARK-CONTRACT.md
configs/
src/
tests/
results/
evidence/
REPORT.md
INTERVIEW-NOTES.md
```

### `REPORT.md`

The report must show:

* technique;
* baseline configuration;
* optimized configuration;
* workload;
* before metrics;
* after metrics;
* percentage change;
* quality check;
* observed trade-off;
* when the optimization helps;
* when it does not help.

### `INTERVIEW-NOTES.md`

The explanation should cover:

* the bottleneck;
* the mechanism;
* the execution path;
* the observed result;
* the trade-off;
* the production implication.

---

## Initial 80/20 Scope

The first implementation phase will prioritize:

1. KV-cache memory and reuse;
2. quantization;
3. prefix caching;
4. speculative decoding;
5. continuous batching;
6. chunked prefill;
7. KV-cache quantization;
8. CUDA Graph or HIP Graph execution.

Only one experiment should be active at a time.

---

## Non-Goals

Track 06 will not:

* become another production inference platform;
* duplicate the ROCm flagship;
* implement every optimization technique immediately;
* claim universal speedups;
* compare configurations without controlled workloads;
* optimize only for GPU utilization;
* publish benchmark results without hardware and software context;
* treat architecture-level model differences as simple runtime toggles.

---

## Repository Boundary

```text
ai-systems-implementation-fluency/
└── track-06-gpu-inference/
    ├── README.md
    ├── CORE-EXPERIMENTS.md
    ├── ADVANCED-EXPERIMENTS.md
    ├── FRONTIER-WATCHLIST.md
    └── micro-builds/
```

The ROCm flagship proves production platform capability.

Track 06 develops implementation fluency in individual inference mechanisms.

---

## Definition of Complete

A Track 06 micro-build is complete when the mechanism can be:

* visualized;
* implemented or configured;
* benchmarked against a baseline;
* forced through a meaningful edge case;
* explained causally;
* defended in an interview;
* summarized through evidence-backed writing.

The governing rule is:

> Do not report that an optimization is faster. Show which bottleneck changed, under what workload, by how much, and at what cost.

