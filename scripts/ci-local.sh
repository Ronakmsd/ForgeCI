#!/usr/bin/env bash
set -euo pipefail

IMAGE=forgeci-demo
TAG=local

echo "==> Test"
python3 -m py_compile app/main.py

echo "==> Docker build"
docker build -t ${IMAGE}:${TAG} -t ${IMAGE}:latest .

echo "==> Load into kind"
kind load docker-image ${IMAGE}:latest --name forgeci

echo "==> Helm deploy"
helm upgrade --install forgeci ./helm/forgeci \
  --set image.repository=${IMAGE} \
  --set image.tag=latest \
  --set image.pullPolicy=Never

echo "==> Wait for rollout"
kubectl rollout status deployment/forgeci --timeout=120s
kubectl get pods -l app=forgeci

echo "==> Done"
