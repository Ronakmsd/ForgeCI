from fastapi import FastAPI
from datetime import datetime, timezone

app = FastAPI(title="ForgeCI Demo Service", version="1.0.0")

@app.get("/")
def root():
    return {
        "service": "forgeci-demo",
        "status": "ok",
        "message": "Cloud-native delivery demo for CI/CD + Helm + Kubernetes"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }

@app.get("/ready")
def ready():
    return {"status": "ready"}
