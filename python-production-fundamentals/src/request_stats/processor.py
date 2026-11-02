
records = [
    {"service": "router", "status": 200, "latency_ms": 42.5},
    {"service": "router", "status": 400, "latency_ms": 25.0},
    {"service": "inference", "status": 503, "latency_ms": 1200.0},
    {"service": "database", "status": 500, "latency_ms": 350.2},
    {"service": "router", "status": 404, "latency_ms": 57.0},
    {"service": "inference", "status": 200, "latency_ms": 180.0},
    {"service": "router", "status": 200, "latency_ms": 38.0},
]

counts = {}
errors = {}

for record in records:
    service = record["service"]
    status = record["status"]

    counts[service] = counts.get(service, 0) + 1 
    errors.setdefault(service, 0)
    
    if status >= 400:
        errors[service] += 1

print("Requests:", counts)
print("Errors:", errors)

