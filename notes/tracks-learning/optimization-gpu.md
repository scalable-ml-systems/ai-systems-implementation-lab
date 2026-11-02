# track 06 - GPU - Optimization experiments
================================================================

Yes. Track 06 should include a frontier backlog, because inference optimization is evolving beyond the article’s original ten techniques.

The clearest 2026 trend is:

The KV cache has become a first-class distributed systems object—not merely a tensor held temporarily on one GPU.

Modern work is increasingly about where KV state lives, how it is compressed, transferred, reused, scheduled, secured, and evicted. A July 2026 survey explicitly describes KV cache as a “first-order memory object” in LLM serving.

Beyond the article’s ten techniques

I would divide the newer techniques into three maturity levels.

1. Production-usable now

These are appropriate Track 06 experiments once the first five baseline optimizations are complete.

A. Chunked prefill

Instead of processing one long prompt in a single large prefill operation:

Long prompt
    ↓
One large prefill
    ↓
Decode requests wait

the runtime splits it:

Long prompt
    ↓
Prefill chunk 1 ─┐
Prefill chunk 2 ─┼─ interleaved with decode work
Prefill chunk 3 ─┘

This helps balance:

compute-heavy prefill;
memory-bandwidth-heavy decode;
TTFT;
inter-token latency;
fairness between long and short requests.

vLLM now describes chunked prefill as a standard optimization for batching prefill chunks together with decode requests.

Good micro-build
Baseline: chunked prefill disabled
Optimized: chunked prefill enabled

Test:

short prompts only;
one very long prompt;
mixed long and short traffic.

Measure:

TTFT p50/p95;
TPOT p50/p95;
short-request interference;
throughput.

Priority: very high.

B. Asynchronous and overlap scheduling

Traditional scheduling can create CPU–GPU bubbles:

CPU schedules
     ↓
GPU executes
     ↓
GPU waits while CPU schedules again

Overlap scheduling tries to perform CPU-side scheduling while the GPU is still processing the previous step:

GPU executes step N
        +
CPU prepares step N+1

Current vLLM configuration describes asynchronous scheduling as a way to reduce gaps in GPU utilization and improve latency and throughput.

Good micro-build
Baseline: synchronous scheduler
Optimized: asynchronous scheduler

Measure:

GPU idle time;
output tokens per second;
scheduling overhead;
p95 latency;
behavior under high concurrency.

Priority: high, but runtime-version dependent.

C. CUDA Graphs and HIP Graphs

Normal execution repeatedly launches kernels from the CPU:

CPU launch
→ GPU kernel
→ CPU launch
→ GPU kernel
→ ...

Graph capture records a repeatable sequence and replays it with less launch overhead:

Capture execution graph once
             ↓
Replay graph repeatedly

Current vLLM supports piecewise and full CUDA/HIP graph execution as part of its serving optimization stack.

Good micro-build
Baseline: eager execution
Optimized: graph-captured execution

Measure across:

batch size;
sequence length;
low versus high concurrency;
static versus changing request shapes.

The key lesson:

Graph capture helps most when CPU launch overhead matters and execution shapes are reusable.

Priority: high, especially because you can compare CUDA and ROCm behavior later.

D. KV-cache quantization

The article discusses model-weight quantization, but KV-cache quantization is a separate optimization.

Model quantization
Reduces weight memory and weight bandwidth

KV-cache quantization
Reduces per-request context memory and decode bandwidth

For long-context or high-concurrency serving, KV cache may consume a major share of GPU memory. Current vLLM versions support lower-precision KV-cache configurations, including FP8 paths; ROCm support differs by datatype and hardware.

Good micro-build
Baseline: BF16/FP16 KV cache
Optimized: FP8 KV cache

Measure:

maximum concurrency;
peak GPU memory;
decode throughput;
TPOT;
long-context accuracy.

Priority: extremely high.

This is more relevant to modern serving than generic weight-only quantization alone.

E. Hierarchical KV-cache offloading

Instead of keeping every reusable KV block in GPU memory:

GPU HBM only

modern systems can use memory tiers:

GPU HBM
   ↓
CPU RAM
   ↓
NVMe or remote cache

Completed KV blocks can be moved to larger but slower tiers and promoted back to GPU when reused. vLLM documents KV offloading to CPU memory and optional secondary tiers, while SGLang’s HiCache overlaps KV loading with model computation.

Good micro-build
Baseline: GPU KV cache only
Optimized: GPU + CPU offload

Workloads:

repeated long prompts;
multi-turn conversations;
cache working set larger than HBM;
low and high cache-hit rates.

Measure:

cache hit rate;
TTFT;
PCIe transfer volume;
GPU-memory savings;
throughput.

The important trade-off:

More cache capacity
        ↕
Higher transfer latency

Priority: very high for long-context and agent workloads.

F. Cache-aware request routing

When several inference replicas exist, routing requests randomly may waste cached prefixes.

Request with prefix A
        ↓
Random replica without prefix A
        ↓
Repeat prefill

A cache-aware router tries to send it to a replica that already owns matching KV blocks:

Request with prefix A
        ↓
Replica containing prefix A
        ↓
Reuse cached prefill

Recent TensorRT-LLM documentation describes globally coordinated KV-cache-aware routing for disaggregated workers.

Good micro-build

This does not initially require a large model. Simulate:

three serving replicas;
cached-prefix ownership;
random routing;
least-loaded routing;
cache-aware routing.

Measure:

cache-hit rate;
estimated prefill work;
load imbalance;
request latency.

Then optionally repeat with real inference replicas.

Priority: high for agentic and multi-turn workloads.

G. Context parallelism

Tensor parallelism divides model computation.

Context parallelism divides work associated with a long sequence across GPUs.

Very long context
       ↓
Split context tokens or attention state
       ↓
Multiple GPUs process context together

Current vLLM documentation presents context parallel deployment as a mechanism for controlling long-context TTFT and expanding available KV-cache capacity during decode.

Good micro-build
Baseline: tensor parallel only
Optimized: context-parallel configuration

Measure:

TTFT as prompt length grows;
maximum context;
per-GPU memory;
communication overhead;
throughput.

Priority: advanced, because it needs multiple GPUs and careful topology analysis.

H. Expert parallelism for MoE models

For mixture-of-experts models, only selected experts execute for each token. The optimization problem becomes:

Which GPU owns each expert?

How are tokens routed?

How expensive is all-to-all communication?

Are some experts overloaded?

Current vLLM supports expert parallel deployment, expert load balancing, and several communication backends optimized for different prefill/decode and single-node/multi-node patterns.

Good micro-build

Compare:

Tensor parallel MoE
versus
Expert parallel MoE

Measure:

tokens per second;
all-to-all communication;
expert-load imbalance;
GPU utilization;
topology sensitivity.

Priority: advanced but highly market-relevant, especially for DeepSeek-style MoE systems.

I. Ultra-low-precision FP4 families

The frontier has moved beyond standard INT4 into hardware-specific floating-point formats:

NVFP4;
MXFP4;
MXFP8;
hardware-native FP8 variants.

Current vLLM lists FP8, MXFP8/MXFP4 and NVFP4 among its quantization formats, while modern TensorRT supports mixed-precision deployment down to FP4 and INT4.

Good micro-build
BF16
versus FP8
versus FP4

Only when the hardware and model support a fair comparison.

Measure:

model memory;
throughput;
TTFT/TPOT;
kernel utilization;
quality degradation.

Priority: medium-to-high, but highly hardware-specific.

2. Emerging and rapidly becoming practical

These are suitable for an experimental Track 06 phase, not the first version.

J. EAGLE-3 and learned speculative drafting

Classic speculative decoding uses a separate small draft model.

Newer approaches train specialized drafters that predict multiple likely future tokens more accurately.

EAGLE-3 uses direct token prediction and multi-layer feature fusion rather than relying only on the target model’s top-layer feature representation.

There are now several related approaches:

Draft model speculation
        ↓
EAGLE / EAGLE-3
        ↓
Parallel EAGLE
        ↓
Adaptive drafting and verification

TensorRT-LLM’s current model-support matrix includes MTP and EAGLE-3 variants for supported architectures.

Possible experiments
standard decode;
two-model speculative decode;
EAGLE-3;
model-native multi-token prediction;
different speculation lengths.

Measure:

accepted tokens per draft;
verification overhead;
TPOT;
throughput at different QPS;
additional memory.

Priority: high frontier value.

K. Adaptive speculative decoding

Fixed speculation length is often suboptimal.

Easy prediction region
→ speculate more tokens

Hard or unstable region
→ speculate fewer tokens

Recent research uses adaptive policies—including reinforcement-learning-based approaches—to choose how much speculation is worthwhile for the current workload or token position.

A 2026 paper also proposes parallelizing speculation and verification themselves, calling the approach speculative speculative decoding.

Micro-build form

Start with a simulator:

Fixed draft length
versus
Acceptance-rate-based adaptive length

Then use a supported runtime.

Priority: research-oriented but excellent for understanding speculation economics.

L. Prefill–decode disaggregation with optimized KV transfer

The article includes disaggregation, but the frontier has moved beyond simply placing prefill and decode on different GPUs.

Current work addresses:

overlapping KV transfer with compute;
direct device-to-device transfer;
different parallel layouts for prefill and decode;
cache-layout transformation;
RDMA/NIXL/UCX transport;
dynamic worker assignment;
cache-aware routing.

TensorRT-LLM now documents overlapping cache transmission with computation and parallel KV transfer across different GPU sets.

However, vLLM still labels its disaggregated-prefill feature experimental, and research shows that disaggregation does not automatically improve performance or energy efficiency—it depends heavily on load and KV-transfer medium.

Priority: advanced testing, not an assumed optimization win.

3. Research/frontier techniques

These are ideal for a frontier-watchlist.md, but should not automatically become implementation work.

M. Dynamic KV-cache eviction

Not every previous token contributes equally to every future token.

Instead of retaining all KV entries:

Keep everything

research systems attempt:

Keep important tokens
Evict low-value tokens
Recover or reload when needed

The difficulty is that token importance can change during decoding.

This is currently a major research area for long-context systems. Recent surveys organize KV-cache optimization into eviction, compression, hybrid-memory, novel-attention, and combined strategies.

Examples
RocketKV combines coarse-grained eviction and sparse attention;
DeltaKV uses residual-based compression and sparse layouts;
CompressKV selects tokens using semantically important retrieval heads.

Status: research and specialized implementations.

N. Sparse KV attention

Instead of every new token attending to every cached token:

Full attention over all previous KV

the runtime selects a smaller relevant subset:

Retrieve important KV blocks
        ↓
Attend only to selected blocks

Potential gain:

lower memory bandwidth;
lower decode cost;
longer contexts.

Risks:

missed evidence;
irregular memory access;
sparse-kernel overhead;
quality degradation.

Recent work such as RocketKV reports end-to-end gains from combining cache compression with sparse attention, but results depend strongly on workload and optimized kernels.

O. Lossy compression with lossless verification

A particularly interesting frontier combines KV compression with speculative verification.

Compressed KV cache
        ↓
Fast approximate draft
        ↓
Verify against full KV state
        ↓
Exact output preserved

VeriCache reports using compressed caches for drafting and full caches for verification, aiming to retain identical outputs while gaining throughput.

This is conceptually similar to speculative decoding, but the speculation happens over memory fidelity, not merely a smaller language model.

Status: research. Very interesting micro-simulation candidate.

P. Selective and adaptive KV transfer

In disaggregated systems, transferring the entire KV cache can saturate the network.

Newer research asks:

Can we transfer only the KV entries that decode is likely to need immediately?

SmartGen, published July 30, 2026, proposes proactive, on-demand and speculative transfer paths rather than sending the entire KV cache uniformly.

KVServe similarly explores service-aware adaptive compression based on workload, bandwidth and SLO conditions.

Status: very recent research—watch, do not prioritize implementation yet.

Q. Adaptive optimization controllers

The deeper frontier is moving from:

Enable one fixed optimization

to:

Observe workload and SLO
        ↓
Choose cache policy
        ↓
Choose batching policy
        ↓
Choose quantization/compression level
        ↓
Adjust dynamically

There may be no universally optimal:

batch size;
speculation length;
KV precision;
eviction policy;
cache tier;
disaggregation strategy.

A 2026 review concludes that no single KV-cache method dominates all deployment scenarios and points toward adaptive multi-stage pipelines.

This is the real systems frontier:

Inference optimization is becoming workload-aware control-plane engineering.

Recommended Track 06 expansion

Do not implement everything.

Use three layers.

Core experiments
01 KV caching
02 Quantization
03 Prefix caching
04 Speculative decoding
05 Continuous batching
06 Chunked prefill
07 KV-cache quantization
08 CUDA/HIP graph execution

These provide the highest practical return.

Advanced experiments
09 Async/overlap scheduling
10 Hierarchical KV offloading
11 Cache-aware routing
12 Context parallelism
13 Expert parallelism
14 EAGLE-3 or MTP speculation
15 Prefill–decode disaggregation

Implement only when suitable hardware and time are available.

Frontier simulations or paper reproductions
16 Dynamic KV eviction
17 Sparse KV attention
18 Adaptive speculation length
19 Selective KV transfer
20 Lossy-cache drafting with full-cache verification
21 SLO-aware adaptive optimization controller

These should begin as:

calculators;
simulations;
trace replays;
small kernel tests;
reduced paper reproductions.

They do not need full production deployments.

Keep a frontier registry

Inside Track 06:

track-06-gpu-inference/
├── CORE-EXPERIMENTS.md
├── ADVANCED-EXPERIMENTS.md
├── FRONTIER-WATCHLIST.md
└── 01-llm-inference-optimization-lab/

For each candidate, record:

Technique:
Layer:
Maturity:
Runtime support:
Hardware required:
Expected benefit:
Primary trade-off:
Can isolate fairly?
Micro-build candidate:
Status:
The strongest takeaway

The article’s ten techniques remain foundational, but the current frontier is clustering around four areas:

1. Smarter scheduling
   chunked prefill, overlap, adaptive batching

2. Smarter KV state management
   quantization, offloading, routing, eviction, compression

3. Faster decoding
   EAGLE-3, MTP, adaptive speculation

4. Distributed inference specialization
   context parallelism, expert parallelism,
   prefill–decode disaggregation
