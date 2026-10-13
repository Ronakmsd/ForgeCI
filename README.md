# ForgeCI — Cloud-Native CI/CD & Delivery Platform

End-to-end DevOps demo: Jenkins pipeline → Docker build → kind (Kubernetes) → Helm deploy.

Built to demonstrate hands-on skills aligned with Cloud DevOps roles (CI/CD, containers, Kubernetes objects, Helm, automation).

## Architecture

Git / local source → Jenkins (Pipeline stages) → Test → Docker build → kind load image → Helm upgrade --install → Kubernetes Deployment + Service (2 replicas) → /health + /ready probes

## Tech stack

- App: Python, FastAPI
- Containers: Docker
- CI/CD: Jenkins (Jenkinsfile), local scripts/ci-local.sh
- Orchestration: Kubernetes via kind (local cluster; same objects as EKS)
- Packaging: Helm chart (Deployment, Service, values, probes)
- IaC concepts: Modular deploy, rollout status, resource limits

## Kubernetes objects used

- Deployment (replicas, probes, resources)
- Service (ClusterIP)
- Helm templates + values.yaml
- Readiness / liveness probes (/ready, /health)

## Quick start

Prerequisites: Docker Desktop, kind, kubectl, Helm

  kind create cluster --name forgeci
  ./scripts/ci-local.sh
  kubectl port-forward svc/forgeci 8090:80
  curl http://127.0.0.1:8090/health

Jenkins: Create Pipeline job using root Jenkinsfile. Stages: Checkout → Test → Build Docker → Load to kind → Deploy with Helm

## Project layout

ForgeCI/
  app/                 FastAPI service
  helm/forgeci/        Helm chart
  k8s/                 Raw manifests
  scripts/ci-local.sh  Full pipeline without Jenkins UI
  Dockerfile
  Jenkinsfile
  README.md

## Troubleshooting

ImagePullBackOff → kind load docker-image forgeci-demo:latest --name forgeci + pullPolicy Never
Port in use → kubectl port-forward svc/forgeci 8090:80
Pods Pending → kubectl describe pod -l app=forgeci

## Resume / interview talking points

- Built Jenkins pipeline stages for test, image build, and Helm-based deploy
- Authored Helm chart with Deployments, Services, resource limits, health probes
- Deployed and debugged on local Kubernetes (kind); same object model as EKS
- Automated end-to-end delivery with ci-local.sh mirroring CI stages
- Troubleshot rollout, image load into kind, and service port-forward

## License

MIT — portfolio / learning project.
