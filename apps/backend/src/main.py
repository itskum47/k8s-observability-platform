from fastapi import FastAPI, Response, status
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest
import os
import socket
import time

app = FastAPI(title="k8s-observability-backend", version="1.0.0")
start_time = time.time()

request_count = Counter(
    "backend_http_requests_total",
    "Total HTTP requests to backend",
    ["method", "path", "status_code"],
)
uptime_gauge = Gauge("backend_uptime_seconds", "Backend process uptime in seconds")


@app.middleware("http")
async def metrics_middleware(request, call_next):
    response = await call_next(request)
    request_count.labels(
        method=request.method,
        path=request.url.path,
        status_code=response.status_code,
    ).inc()
    return response


@app.get("/healthz")
def liveness_probe():
    return {"status": "ok"}


@app.get("/readyz")
def readiness_probe():
    if os.getenv("APP_ENV") is None:
        return Response(
            content='{"status":"not-ready"}',
            media_type="application/json",
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
        )
    return {"status": "ready"}


@app.get("/api/v1/info")
def info():
    uptime_gauge.set(time.time() - start_time)
    return {
        "service": "backend",
        "environment": os.getenv("APP_ENV", "unknown"),
        "version": os.getenv("APP_VERSION", "latest"),
        "hostname": socket.gethostname(),
    }


@app.get("/metrics")
def metrics():
    uptime_gauge.set(time.time() - start_time)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
