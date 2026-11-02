import json

counts = {}
errors = {}
latencies = {}


with open("data/requests.jsonl", "r", encoding="utf-8") as file: 
    for line in file: 
        record = json.loads(line)

        service = record["service"]
        status = record["status"]
        latency = record["latency_ms"]

        # Request counts
        counts[service] = counts.get(service, 0) + 1 

        #Error counts
        errors.setdefault(service, 0)
        if status >= 400:
            errors[service] += 1

        # Latency aggregation
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

print("Requests:", counts)
print("Errors:", errors)

for service, stats in latencies.items():
    average = stats["total"] / stats["count"]
    print(service, "Average latency:", round(average, 2))

