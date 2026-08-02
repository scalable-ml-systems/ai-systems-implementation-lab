```markdown
# Experiment 01 — KV Caching

## Question

How does enabling the transformer KV cache affect autoregressive generation
latency, output-token throughput, and peak GPU memory?

## Baseline

Generate tokens with KV caching disabled.

## Optimized Case

Generate the same tokens with KV caching enabled.

## Controlled Variables

The following must remain identical:

- hardware;
- model and model revision;
- runtime and dependency versions;
- prompt;
- input-token length;
- output-token limit;
- sampling configuration;
- random seed;
- warm-up count;
- measured-run count.

## Initial Metrics

- end-to-end generation latency;
- output tokens per second;
- peak allocated GPU memory;
- generated token count;
- output equivalence or quality check.

## Hypothesis

KV caching will reduce repeated attention computation during autoregressive
decoding and improve output-token throughput.

The expected trade-off is increased GPU memory consumption.

## Required Outputs

Each benchmark execution must create a new run directory containing:

```text
environment.json
raw-results.jsonl
summary.json
comparison.csv
REPORT.md

## Locked Benchmark Configuration

| Component | Selection |
|---|---|
| GPU | 1 × NVIDIA RTX 4090 24 GB |
| Model | HuggingFaceTB/SmolLM2-1.7B-Instruct |
| Model revision | 06633a3e0bcdf1c31bd8ce0a27cb764aff26d6a9 |
| Precision | FP16 |
| Runtime | Hugging Face Transformers |
| Python | 3.12 |
| PyTorch | 2.13.0 |
| Transformers | 5.14.1 |
| CUDA build | CUDA 13.0 |
| Attention backend | SDPA |
| Batch size | 1 |

## Comparison

Baseline:

    use_cache=False

Optimized:

    use_cache=True
    cache_implementation="dynamic"

No other model or generation setting changes between the two cases.

## Workload

- Input length: 512 tokens
- Output lengths: 32, 64, 128, and 256 tokens
- Batch size: 1
- Decoding: greedy
- Warm-up runs: 2 per mode
- Measured runs: 10 paired runs per mode and output length
- Execution order: alternating cached and uncached
- Model compilation: disabled
- Quantization: disabled

## Measurements

- generation latency;
- effective output tokens per second;
- peak allocated GPU memory;
- generated-token equality;
- cached-versus-uncached speedup.

## Reporting Boundary

This is a single-request mechanism benchmark.

It does not measure production serving throughput, concurrency, continuous
batching, PagedAttention, or multi-GPU execution.

## Status

Benchmark contract locked.
