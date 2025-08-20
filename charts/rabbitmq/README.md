# RabbitMQ Helm Chart

A messaging broker that implements the Advanced Message Queuing Protocol (AMQP) 0-9-1.

## Quick Start

### Prerequisites

- Kubernetes 1.24+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

### Installation

To install the chart with the release name `my-rabbitmq`:

```bash
$ helm install my-rabbitmq oci://registry-1.docker.io/cloudpirates/rabbitmq
```

To install with custom values:

```bash
helm install my-rabbitmq oci://registry-1.docker.io/cloudpirates/rabbitmq -f my-values.yaml
```

Or install directly from the local chart:

```bash
$ helm install my-rabbitmq ./charts/rabbitmq
```

### Getting Started

1. Get the RabbitMQ password:

```bash
kubectl get secret my-rabbitmq -o jsonpath="{.data.password}" | base64 -d
```

2. Access RabbitMQ Management UI:

```bash
kubectl port-forward svc/my-rabbitmq 15672:15672
```

Then visit http://localhost:15672 and login with username `admin` and the password from step 1.

3. Connect to RabbitMQ from inside the cluster:

```bash
kubectl run rabbitmq-client --rm --tty -i --restart='Never' \
    --image rabbitmq:4.0.2-management -- bash

# Inside the pod:
rabbitmqctl status
```

## Configuration

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.registry` | RabbitMQ image registry | `docker.io` |
| `image.repository` | RabbitMQ image repository | `rabbitmq` |
| `image.tag` | RabbitMQ image tag | `4.0.2-management@sha256:...` |
| `image.pullPolicy` | Image pull policy | `Always` |
| `global.imageRegistry` | Global Docker image registry override | `""` |
| `global.imagePullSecrets` | Global Docker registry secret names | `[]` |

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | String to partially override rabbitmq.fullname | `""` |
| `fullnameOverride` | String to fully override rabbitmq.fullname | `""` |
| `commonLabels` | Labels to add to all deployed objects | `{}` |
| `commonAnnotations` | Annotations to add to all deployed objects | `{}` |
| `replicaCount` | Number of RabbitMQ replicas to deploy | `1` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.amqpPort` | RabbitMQ AMQP service port | `5672` |
| `service.managementPort` | RabbitMQ management UI port | `15672` |
| `service.epmdPort` | RabbitMQ EPMD port | `4369` |
| `service.distPort` | RabbitMQ distribution port | `25672` |

### Authentication

| Parameter | Description | Default |
|-----------|-------------|---------|
| `auth.enabled` | Enable RabbitMQ authentication | `true` |
| `auth.username` | RabbitMQ default username | `admin` |
| `auth.password` | RabbitMQ password (if empty, random password will be generated) | `""` |
| `auth.erlangCookie` | Erlang cookie for clustering (if empty, random cookie will be generated) | `""` |
| `auth.existingSecret` | Name of existing secret containing RabbitMQ credentials | `""` |
| `auth.existingPasswordKey` | Key in existing secret containing RabbitMQ password | `password` |
| `auth.existingErlangCookieKey` | Key in existing secret containing Erlang cookie | `erlang-cookie` |

### Clustering Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `clustering.enabled` | Enable RabbitMQ clustering | `false` |
| `clustering.replicaCount` | Number of RabbitMQ replicas when clustering is enabled | `3` |

### RabbitMQ Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.memoryHighWatermark` | RabbitMQ memory high watermark | `0.4` |
| `config.memoryHighWatermarkType` | Memory high watermark type (relative\|absolute) | `relative` |
| `config.diskFreeLimit` | RabbitMQ disk free limit | `2GB` |
| `config.extraConfiguration` | Additional RabbitMQ configuration | `""` |
| `config.advancedConfiguration` | Advanced RabbitMQ configuration | `""` |

### LDAP Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ldap.enabled` | Enable LDAP authentication | `false` |
| `ldap.server` | LDAP server hostname | `""` |
| `ldap.port` | LDAP server port | `389` |
| `ldap.userDnPattern` | LDAP user DN pattern | `cn=${username},ou=People,dc=example,dc=org` |

### Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.storageClass` | Storage class for persistent volume | `""` |
| `persistence.accessMode` | Access mode for persistent volume | `ReadWriteOnce` |
| `persistence.size` | Size of persistent volume | `8Gi` |
| `persistence.annotations` | Annotations for persistent volume claims | `{}` |

### Metrics Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `metrics.enabled` | Enable RabbitMQ metrics | `false` |
| `metrics.port` | RabbitMQ metrics port | `15692` |
| `metrics.serviceMonitor.enabled` | Create ServiceMonitor for Prometheus monitoring | `false` |
| `metrics.serviceMonitor.namespace` | Namespace for ServiceMonitor | `""` |
| `metrics.serviceMonitor.labels` | Labels for ServiceMonitor | `{}` |
| `metrics.serviceMonitor.annotations` | Annotations for ServiceMonitor | `{}` |
| `metrics.serviceMonitor.interval` | Scrape interval | `30s` |
| `metrics.serviceMonitor.scrapeTimeout` | Scrape timeout | `10s` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress for RabbitMQ management | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | `[{host: "rabbitmq.local", paths: [{path: "/", pathType: "Prefix"}]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Resource Management

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.memory` | Memory limit | `2Gi` |
| `resources.limits.cpu` | CPU limit | `1000m` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `1Gi` |

### Pod Assignment

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node selector for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity rules for pod assignment | `{}` |

### Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `containerSecurityContext.runAsUser` | User ID to run the container | `999` |
| `containerSecurityContext.runAsGroup` | Group ID to run the container | `999` |
| `containerSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation | `false` |
| `podSecurityContext.fsGroup` | Pod's Security Context fsGroup | `999` |

### Health Checks

#### Liveness Probe

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.enabled` | Enable liveness probe | `true` |
| `livenessProbe.initialDelaySeconds` | Initial delay before starting probes | `120` |
| `livenessProbe.periodSeconds` | How often to perform the probe | `30` |
| `livenessProbe.timeoutSeconds` | Timeout for each probe attempt | `20` |
| `livenessProbe.failureThreshold` | Number of failures before pod is restarted | `6` |
| `livenessProbe.successThreshold` | Number of successes to mark probe as successful | `1` |

#### Readiness Probe

| Parameter | Description | Default |
|-----------|-------------|---------|
| `readinessProbe.enabled` | Enable readiness probe | `true` |
| `readinessProbe.initialDelaySeconds` | Initial delay before starting probes | `10` |
| `readinessProbe.periodSeconds` | How often to perform the probe | `30` |
| `readinessProbe.timeoutSeconds` | Timeout for each probe attempt | `20` |
| `readinessProbe.failureThreshold` | Number of failures before pod is marked unready | `3` |
| `readinessProbe.successThreshold` | Number of successes to mark probe as successful | `1` |

### Additional Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `extraEnv` | Additional environment variables | `[]` |
| `extraVolumes` | Additional volumes to add to the pod | `[]` |
| `extraVolumeMounts` | Additional volume mounts for RabbitMQ container | `[]` |

## Examples

### Basic Deployment
```bash
helm install my-rabbitmq ./charts/rabbitmq
```

### Enable Clustering
```yaml
# values-cluster.yaml
clustering:
  enabled: true
  replicaCount: 3

resources:
  requests:
    memory: 2Gi
    cpu: 200m
  limits:
    memory: 4Gi
    cpu: 1000m
```

### Enable Metrics with ServiceMonitor
```yaml
# values-monitoring.yaml
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
    labels:
      prometheus: kube-prometheus
```

### Using Existing Secret for Authentication
```yaml
# values-external-secret.yaml
auth:
  enabled: true
  existingSecret: "rabbitmq-credentials"
  existingPasswordKey: "password"
  existingErlangCookieKey: "erlang-cookie"
```

### Enable LDAP Authentication
```yaml
# values-ldap.yaml
ldap:
  enabled: true
  server: "ldap.example.com"
  port: 389
  userDnPattern: "cn=${username},ou=Users,dc=example,dc=com"
```

## Upgrading

To upgrade your RabbitMQ installation:

```bash
helm upgrade my-rabbitmq oci://registry-1.docker.io/cloudpirates/rabbitmq
```

## Uninstalling

To uninstall/delete the RabbitMQ deployment:

```bash
helm delete my-rabbitmq
```

## Testing

This chart includes a comprehensive test suite to verify all RabbitMQ functionality.

### Running Tests

#### 1. Helm Unit Tests
```bash
# Test template rendering and configuration
helm unittest charts/rabbitmq
```

#### 2. Integration Tests
```bash
# Test single node deployment
./charts/rabbitmq/tests/integration-test.sh rabbitmq my-rabbitmq

# Test all functionality
./charts/rabbitmq/tests/run-all-tests.sh
```

#### 3. Clustering Tests
```bash
# Deploy clustered RabbitMQ first
helm install my-cluster ./charts/rabbitmq \
  --set clustering.enabled=true \
  --set clustering.replicaCount=3

# Run clustering tests
./charts/rabbitmq/tests/clustering-test.sh rabbitmq my-cluster 3
```

#### 4. Performance Tests
```bash
# Test message throughput (requires python3 and pika)
./charts/rabbitmq/tests/performance-test.sh rabbitmq my-rabbitmq 60 1000
```

### Test Coverage

The test suite verifies:
- ✅ Pod deployment and readiness
- ✅ Service configuration and ports
- ✅ Authentication and secrets
- ✅ Configuration management
- ✅ Persistence and storage
- ✅ Clustering functionality
- ✅ Message publishing/consuming
- ✅ Management API access
- ✅ Health checks and probes
- ✅ Security contexts
- ✅ Resource limits
- ✅ LDAP integration (when enabled)
- ✅ Metrics and monitoring (when enabled)
- ✅ Ingress configuration (when enabled)
- ✅ Node failure and recovery
- ✅ Performance and throughput

### Prerequisites for Full Testing

```bash
# Install required tools
pip3 install pika  # For AMQP tests
```

## Getting Support

For issues related to this Helm chart, please check:
- [RabbitMQ Documentation](https://www.rabbitmq.com/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- Chart repository issues