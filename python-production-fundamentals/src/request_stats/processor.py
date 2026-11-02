
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
latencies = {}

for record in records:
    service = record["service"]
    status = record["status"]
    latency = record["latency_ms"]

    counts[service] = counts.get(service, 0) + 1 
    errors.setdefault(service, 0)
    
    if status >= 400:
        errors[service] += 1

    if service not in latencies:
        latencies[service] = {
            "count" : 0,
            "total" : 0,
            "min" : latency, 
            "max" : latency
        }
    
    stats = latencies[service]

    stats["count"] += 1
    stats["total"] += latency
    stats["min"] = min(stats["min"], latency)
    stats["max"] = max(stats["max"], latency)

for service, stats in latencies.items():
    average = stats["total"] / stats["count"]

    print(
        service,
        "Count:", stats["count"],
        "Min:", stats["min"],
        "Max:", stats["max"],
        "Average:", round(average, 2)
    )

print("Requests:", counts)
print("Errors:", errors)

