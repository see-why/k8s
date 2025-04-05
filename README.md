# Kubernetes Orchestration Demo

A comprehensive demonstration of Kubernetes orchestration capabilities, showcasing how to deploy, manage, and scale containerized applications in a Kubernetes environment.

## Overview

This project demonstrates the deployment of a multi-service application on Kubernetes, including:
- API service
- Web frontend
- Crawler service
- Metrics server

The application showcases various Kubernetes concepts such as:
- Deployments
- Services
- ConfigMaps
- PersistentVolumeClaims
- Ingress
- Resource management

## Prerequisites

- Kubernetes cluster (local or cloud-based)
- kubectl CLI tool
- Docker (for building images)

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/k8s.git
   cd k8s
   ```

2. Apply the Kubernetes configurations:
   ```bash
   kubectl apply -f api-configmap.yaml
   kubectl apply -f api-pvc.yaml
   kubectl apply -f api-deployment.yaml
   kubectl apply -f crawler-service.yaml
   kubectl apply -f web-deployment.yaml
   kubectl apply -f app-ingress.yaml
   ```

3. Verify the deployment:
   ```bash
   kubectl get pods
   kubectl get services
   ```

## Architecture

The application consists of the following components:

- **API Service**: Backend service that handles data processing
- **Web Frontend**: User interface for interacting with the application
- **Crawler Service**: Service for data collection and processing
- **Metrics Server**: Provides monitoring capabilities

## Configuration

The application uses ConfigMaps to manage configuration settings. Key configuration files include:
- `api-configmap.yaml`: Contains API service configuration
- `crawler-service.yaml`: Defines the crawler service

## Troubleshooting

If you encounter issues with the deployment:

1. Check the status of pods:
   ```bash
   kubectl describe pod <pod-name>
   ```

2. View logs:
   ```bash
   kubectl logs <pod-name>
   ```

3. Verify ConfigMap and PVC status:
   ```bash
   kubectl get configmap
   kubectl get pvc
   ```

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
