

Revised Track 01 — Four 80/20 Python Micro-Builds

These four projects cover most of the Python knowledge needed for systems, platform, AI infrastructure, and interview work.

Micro-Build 1 — System Qualification CLI
Real use case

Build a command-line tool that determines whether a machine has the prerequisites required to run an application.

Example checks:

Python version
Required command exists
Configuration file exists
Directory is writable
Local service port is reachable

Output:

{
  "overall_status": "FAILED",
  "checks": [
    {
      "name": "python_version",
      "status": "PASSED"
    },
    {
      "name": "required_command",
      "status": "FAILED",
      "reason": "command not found"
    }
  ]
}
Python concepts learned together
Python execution and imports;
modules and packages;
pyproject.toml;
functions;
dataclasses;
type hints;
dictionaries and lists;
pathlib;
subprocesses;
custom exceptions;
structured logging;
JSON serialization;
CLI arguments;
stdout, stderr, and exit codes;
pytest.
Deliberate failures
required command missing;
subprocess timeout;
configuration file malformed;
output directory not writable.
Interview fluency gained

You should be able to explain:

how Python locates a package;
why python -m differs from direct script execution;
how subprocess exit codes work;
how failures propagate;
why logs and machine-readable output are different;
how a CLI communicates success or failure to automation.
What happens to the current Lab 01?

It becomes the first implementation slice of this project.

We keep what you already learned about:

execution
modules
imports
editable installation

But we stop treating imports as a long standalone subject. They become part of building the qualification CLI correctly.

Micro-Build 2 — Concurrent Dependency Health Checker
Real use case

Build a service that checks several application dependencies concurrently:

Database endpoint
Model server
Vector database
Configuration service

The dependencies can initially be simulated local HTTP endpoints.

Output:

{
  "system_status": "DEGRADED",
  "dependencies": {
    "model_server": {
      "status": "HEALTHY",
      "latency_ms": 42
    },
    "vector_store": {
      "status": "TIMEOUT"
    }
  }
}
Python concepts learned together
HTTP requests;
Pydantic configuration models;
environment variables;
synchronous versus asynchronous execution;
async and await;
concurrent fan-out;
timeouts;
cancellation;
partial failure;
bounded retries;
exponential backoff;
dependency injection;
fakes;
pytest parametrization;
latency measurement.
Deliberate failures
one dependency returns 503;
one dependency times out;
one returns malformed JSON;
all dependencies fail;
retry causes excessive delay.
Interview fluency gained

You should be able to explain:

why async helps I/O-bound work;
why async does not make CPU work faster;
timeout versus retry;
why retries must be bounded;
how partial failure affects system health;
how to test external dependencies without calling real services.
Micro-Build 3 — Task Submission and State API
Real use case

Build a small FastAPI service that accepts tasks and tracks their state.

POST /tasks
GET /tasks/{task_id}
POST /tasks/{task_id}/start
POST /tasks/{task_id}/complete
POST /tasks/{task_id}/fail

State model:

PENDING
   ↓
RUNNING
  ↙   ↘
FAILED  COMPLETED
Python concepts learned together
FastAPI request lifecycle;
request and response models;
Pydantic validation;
classes and dataclasses;
enums;
mutable versus immutable objects;
copying;
state ownership;
valid transition rules;
domain exceptions;
HTTP error mapping;
serialization;
dependency injection;
unit and API tests.
Deliberate failures
malformed task request;
duplicate task ID;
missing task;
illegal state transition;
COMPLETED → RUNNING;
shared mutable object contaminates another task.
Concrete mutability lesson

Instead of studying mutability in isolation, we introduce a real bug:

class TaskStore:
    tasks = {}

Every instance accidentally shares the same dictionary.

Or:

def create_task(tags=[]):
    tags.append("new")

Every call shares the same default list.

You observe the failure in the running task service, diagnose it, and correct it.

Interview fluency gained

You should be able to explain:

how an HTTP request moves through FastAPI;
type hints versus runtime validation;
validation failure versus business-rule failure;
state versus event;
where transition rules belong;
why shared mutable defaults cause bugs;
how to test an invalid transition.
Micro-Build 4 — Resilient Background Worker
Real use case

Build a worker that processes queued maintenance tasks.

Examples:

collect system information
archive a log file
validate a configuration
generate a report

Flow:

Queue
  ↓
Worker receives task
  ↓
Task executes
  ├── Success → record completion
  ├── Transient failure → retry
  └── Permanent failure → reject
Python concepts learned together
queues;
producer and consumer;
threads versus processes versus async;
worker lifecycle;
signals;
SIGTERM;
graceful shutdown;
resource cleanup;
context managers;
race conditions;
locking;
idempotency basics;
retry behavior;
poison messages;
structured logging;
checkpoint files;
test doubles.
Deliberate failures
worker receives SIGTERM during processing;
task repeatedly fails;
duplicate task submitted;
two workers update the same result;
cleanup raises an exception;
worker exits without acknowledging the task.
Interview fluency gained

You should be able to explain:

process versus thread versus coroutine;
what happens when Kubernetes terminates a worker;
why graceful shutdown matters;
how duplicate processing occurs;
why retries can duplicate side effects;
what a race condition looks like;
how locks protect critical sections.
What these four builds cover
Python requirement	Project
Imports and packaging	System Qualification CLI
Functions and data structures	All four
Dataclasses and typing	CLI and Task API
Mutability and copying	Task API
Exceptions	All four
Logging	All four
File handling	CLI and Worker
JSON and configuration	CLI and Health Checker
HTTP clients	Health Checker
FastAPI	Task API
Pytest	All four
Mocks and fakes	Health Checker and Worker
Subprocesses	CLI
Signals	Worker
Async	Health Checker
Queues	Worker
Race conditions	Worker
Retries and timeouts	Health Checker and Worker
Idempotency	Worker
CLI and exit codes	CLI
Debugging	Every project

We are not deleting important concepts. We are learning them in context.

The Feynman implementation method

Each micro-build follows the same five-stage process.

1. Explain the problem in plain language

Before writing code, answer:

What real problem are we solving?

For the qualification CLI:

A deployment should not begin until we know the machine has the commands, files, permissions, and runtime configuration the application requires.

No Python terminology yet.

2. Draw the system using five boxes or fewer
CLI request
    ↓
Run qualification checks
    ↓
Collect results
    ↓
Calculate overall status
    ↓
Print report and exit

If the diagram needs twenty boxes, the micro-build is too large.

3. Predict behavior before running it

Write:

Given:
The required command does not exist.

When:
The command check executes.

Then:
The check returns FAILED.

The program:
Writes the diagnostic to stderr,
includes the failure in the JSON report,
and exits with code 1.

This turns coding into hypothesis testing.

4. Build, break, and explain

After implementation, explain without reading the code:

Where does input enter?

Which function owns each decision?

What external operation happens?

What can fail?

How is the failure represented?

What determines the exit code?

Any point where the explanation becomes vague identifies the real learning gap.

We study only that gap—not an entire Python chapter.

5. Rebuild the central mechanism

Do not rebuild the entire repository.

For the qualification CLI, rebuild only:

one check contract
one concrete check
result aggregation
exit-code calculation

For the Task API, rebuild only:

task model
transition table
transition function
invalid-transition test

That is enough to prove ownership.

Standard completion package

Each micro-build contains only:

README.md
SYSTEM-DIAGRAM.md
src/
tests/
evidence/
INTERVIEW-NOTES.md
README.md

Explain:

the real problem;
what the system does;
how to run it.
SYSTEM-DIAGRAM.md

One normal flow and one failure flow.

evidence/

Capture:

one successful run;
one failed run;
logs;
test output.
INTERVIEW-NOTES.md

Answer:

Explain the system in 60 seconds.

Trace one request from input to output.

What failed?

How did you find the cause?

What Python behavior mattered?

What trade-off did you make?

What would change in production?
Strict 80/20 boundaries

Each project gets:

one real use case;
no frontend;
no cloud deployment;
no unnecessary database;
no framework abstraction layer;
no more than five or six main source files;
three meaningful failure cases;
one primary system diagram;
one concise write-up.

We do not add features merely to demonstrate syntax.

The governing rule is:

Learn a Python concept only when the working system needs it or a failure exposes it.
