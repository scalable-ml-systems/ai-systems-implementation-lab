# Track 06 — GPU and LLM Inference Experiments

## Objective

Build small, reproducible experiments that measure how individual LLM
inference optimizations affect latency, throughput, GPU memory, and output
quality.

Each experiment must show:

1. the question;
2. the baseline;
3. the optimization;
4. the controlled workload;
5. the before-and-after measurements;
6. the trade-off;
7. the conclusion.

## Current Experiments

| ID | Experiment | Status |
|---|---|---|
| 01 | KV caching | Scoping |

## Rules

- Test one primary change at a time.
- Keep baseline and optimized workloads identical.
- Preserve raw results.
- Record hardware, model, runtime, and dependency versions.
- Retain failed and negative results.
- Generate the report from measured data.
- Do not claim that a result applies outside the tested workload.

## Reproducibility Standard

Another engineer must be able to:

```text
clone
→ install pinned dependencies
→ run one command
→ reproduce the experiment
→ inspect raw results
→ generate the report

