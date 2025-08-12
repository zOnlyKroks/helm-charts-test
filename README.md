# CloudPirates Open Source Helm Charts

A curated collection of production-ready Helm charts for open-source cloud-native applications. This repository provides secure, well-documented, and configurable Helm charts following cloud-native best practices. This project is called "nonami" ;-)

## Available Charts

| Chart | Description | Version | App Version |
|-------|-------------|---------|-------------|
| [MariaDB](charts/mariadb/) | High-performance, open-source relational database server that is a drop-in replacement for MySQL | 1.0.0 | 11.8.2 |
| [MinIO](charts/minio/) | High Performance Object Storage compatible with Amazon S3 APIs | 0.1.0 | 2024.8.17 |
| [MongoDB](charts/mongodb/) | Popular document-oriented NoSQL database | - | 8.0.12 |
| [Redis](charts/redis/) | In-memory data structure store, used as a database, cache, and message broker | - | 8.2.0 |
| [Valkey](charts/valkey/) | A Helm chart for Valkey - High performance in-memory data structure store, fork of Redis | - | 8.1.3 |

## Quick Start

### Prerequisites

- Kubernetes 1.24+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

### Installing Charts

1. **Add the repository**:
   ```bash
   helm repo add cloudpirates oci://registry-1.docker.io/cloudpirates
   helm repo update
   ```

2. **Or clone and install locally**:
   ```bash
   git clone git@github.com:CloudPirates-io/helm-charts.git
   cd helm-charts
   ```

3. **Install a chart**:
   ```bash
   # From repository
   helm install my-release cloudpirates/<chart-name>
   
   # From local clone
   helm install my-release ./charts/<chart-name>
   ```

## Chart Features

All charts in this repository provide:

### 🔒 **Security First**
- Non-root containers by default
- Read-only root filesystems where possible
- Dropped Linux capabilities
- Security contexts configured
- No hardcoded credentials

### 📊 **Production Ready**
- Comprehensive health checks (liveness, readiness, startup probes)
- Resource requests and limits support
- Persistent storage configurations
- Rolling update strategies
- Health check endpoints

### 🎛️ **Highly Configurable**
- Extensive values.yaml with detailed documentation
- Support for existing secrets and ConfigMaps
- Flexible ingress configurations
- Service account customization
- Common labels and annotations support

### 🚀 **Cloud Native**
- Node selection and affinity rules
- Init containers where appropriate

## Configuration

Each chart provides extensive configuration options through `values.yaml`. Key configuration areas include:

- **Authentication & Security**: User credentials, existing secrets, security contexts
- **Storage**: Persistent volumes, storage classes, backup configurations  
- **Networking**: Services, ingress, network policies
- **Scaling**: Replica counts, autoscaling, resource limits
- **Monitoring**: Metrics, service monitors, health checks

Refer to individual chart READMEs for detailed configuration options.

## Contributing

1. **Follow Patterns**: Use existing charts as templates
2. **Test Thoroughly**: Ensure charts pass linting and installation tests
3. **Document Completely**: Include comprehensive README and parameter documentation

### Development Commands

```bash
# Lint chart
helm lint ./charts/<chart-name>

# Render templates locally
helm template test-release ./charts/<chart-name> -n test

# Install for testing
helm install test-release ./charts/<chart-name> -n test

# Run chart tests
helm test test-release -n test

# Package chart
helm package ./charts/<chart-name>
```

## Support

### Chart Issues
For issues specific to these Helm charts:
- Check individual chart README files for troubleshooting
- Review chart documentation and examples
- Verify configuration values
- Open an issue on GitHub
