Updated repository structure
ai-systems-implementation-fluency/
├── track-01-python-foundations/
├── track-02-linux-containers/
├── track-03-kubernetes/
├── track-04-ai-systems/
│   ├── 01-llm-request-lifecycle/
│   ├── 02-structured-output-validation/
│   ├── 03-tool-calling/
│   ├── 04-mcp-server-client/
│   ├── 05-basic-rag/
│   ├── 06-chunking-retrieval/
│   ├── 07-hybrid-search-reranking/
│   ├── 08-rag-evaluation/
│   ├── 09-bounded-agent-loop/
│   ├── 10-state-vs-memory/
│   ├── 11-prompt-injection-tool-safety/
│   └── 12-llm-observability/
├── track-05-distributed-systems/
└── track-06-gpu-inference/
Standard AI lab deliverables

Each AI lab should produce:

01-problem.md
02-system-flow.md
03-hypothesis.md
src/
tests/
evidence/
04-interview-explanation.md

The interview explanation should answer:

What problem does this mechanism solve?

Trace one request end to end.

What part is deterministic?

What part is probabilistic?

What can fail?

How is the failure detected?

What evidence proves success?

What trade-off does the design introduce?
