# MinIO Helm Chart

A Helm chart for MinIO - High Performance Object Storage compatible with Amazon S3 APIs. MinIO is a high-performance, distributed object storage server designed for large-scale data infrastructure.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-minio`:

```bash
$ helm repo add cloudpirates oci://registry-1.docker.io/cloudpirates
$ helm install my-minio cloudpirates/minio
```

To install with custom values:

```bash
helm install my-minio cloudpirates/minio -f my-values.yaml
```

Or install directly from the local chart:

```bash
$ helm install my-minio ./charts/minio
```

The command deploys MinIO on the Kubernetes cluster in the default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-minio` deployment:

```bash
$ helm uninstall my-minio
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the MinIO chart and their default values.

### Global parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `""` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` |

### MinIO image configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.registry` | MinIO image registry | `docker.io` |
| `image.repository` | MinIO image repository | `minio/minio` |
| `image.tag` | MinIO image tag (immutable tags are recommended) | `"RELEASE.2024-08-17T01-24-54Z"` |
| `image.digest` | MinIO image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""` |
| `image.pullPolicy` | MinIO image pull policy | `IfNotPresent` |

### MinIO Authentication

| Parameter | Description | Default |
|-----------|-------------|---------|
| `auth.rootUser` | MinIO root username | `"admin"` |
| `auth.rootPassword` | MinIO root password. If not set, a random password will be generated | `""` |
| `auth.existingSecret` | Name of existing secret containing MinIO credentials | `""` |
| `auth.existingSecretUserKey` | Key in existing secret containing username | `"user"` |
| `auth.existingSecretPasswordKey` | Key in existing secret containing password | `"password"` |

### MinIO configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.region` | MinIO server default region | `""` |
| `config.browserEnabled` | Enable MinIO web browser | `true` |
| `config.domain` | MinIO server domain | `""` |
| `config.serverUrl` | MinIO server URL for console | `""` |
| `config.extraEnvVars` | Extra environment variables to be set on MinIO containers | `[]` |

### Deployment configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of MinIO replicas to deploy | `1` |
| `nameOverride` | String to partially override minio.fullname | `""` |
| `fullnameOverride` | String to fully override minio.fullname | `""` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.automount` | Automatically mount a ServiceAccount's API credentials | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.name` | The name of the service account to use | `""` |

### Pod annotations and labels

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podAnnotations` | Map of annotations to add to the pods | `{}` |
| `podLabels` | Map of labels to add to the pods | `{}` |

### Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podSecurityContext.fsGroup` | Group ID for the volumes of the pod | `1000` |
| `securityContext.allowPrivilegeEscalation` | Enable container privilege escalation | `false` |
| `securityContext.runAsNonRoot` | Configure the container to run as a non-root user | `true` |
| `securityContext.runAsUser` | User ID for the MinIO container | `1000` |
| `securityContext.runAsGroup` | Group ID for the MinIO container | `1000` |
| `securityContext.readOnlyRootFilesystem` | Mount container root filesystem as read-only | `true` |
| `securityContext.capabilities.drop` | Linux capabilities to be dropped | `["ALL"]` |

### Service configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | MinIO service type | `ClusterIP` |
| `service.port` | MinIO service port | `9000` |
| `service.targetPort` | MinIO container port | `9000` |
| `service.consolePort` | MinIO console service port | `9090` |
| `service.consoleTargetPort` | MinIO console container port | `9090` |
| `service.annotations` | Service annotations | `{}` |

### Ingress configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress record generation for MinIO | `false` |
| `ingress.className` | IngressClass that will be used to implement the Ingress | `""` |
| `ingress.annotations` | Additional annotations for the Ingress resource | `{}` |
| `ingress.hosts[0].host` | Hostname for MinIO ingress | `minio.local` |
| `ingress.hosts[0].paths[0].path` | Path for MinIO ingress | `/` |
| `ingress.hosts[0].paths[0].pathType` | Path type for MinIO ingress | `Prefix` |
| `ingress.tls` | TLS configuration for MinIO ingress | `[]` |

### Console Ingress configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `consoleIngress.enabled` | Enable ingress record generation for MinIO Console | `false` |
| `consoleIngress.className` | IngressClass that will be used to implement the Ingress | `""` |
| `consoleIngress.annotations` | Additional annotations for the Console Ingress resource | `{}` |
| `consoleIngress.hosts[0].host` | Hostname for MinIO Console ingress | `minio-console.local` |
| `consoleIngress.hosts[0].paths[0].path` | Path for MinIO Console ingress | `/` |
| `consoleIngress.hosts[0].paths[0].pathType` | Path type for MinIO Console ingress | `Prefix` |
| `consoleIngress.tls` | TLS configuration for MinIO Console ingress | `[]` |

### Resources

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources` | The resources to allocate for the container | `{}` |

### Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence using Persistent Volume Claims | `true` |
| `persistence.storageClass` | Persistent Volume storage class | `""` |
| `persistence.annotations` | Persistent Volume Claim annotations | `{}` |
| `persistence.size` | Persistent Volume size | `10Gi` |
| `persistence.accessModes` | Persistent Volume access modes | `["ReadWriteOnce"]` |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence | `""` |

### Liveness and readiness probes

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.enabled` | Enable livenessProbe on MinIO containers | `true` |
| `livenessProbe.initialDelaySeconds` | Initial delay seconds for livenessProbe | `30` |
| `livenessProbe.periodSeconds` | Period seconds for livenessProbe | `10` |
| `livenessProbe.timeoutSeconds` | Timeout seconds for livenessProbe | `5` |
| `livenessProbe.failureThreshold` | Failure threshold for livenessProbe | `3` |
| `livenessProbe.successThreshold` | Success threshold for livenessProbe | `1` |
| `readinessProbe.enabled` | Enable readinessProbe on MinIO containers | `true` |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe | `5` |
| `readinessProbe.periodSeconds` | Period seconds for readinessProbe | `5` |
| `readinessProbe.timeoutSeconds` | Timeout seconds for readinessProbe | `3` |
| `readinessProbe.failureThreshold` | Failure threshold for readinessProbe | `3` |
| `readinessProbe.successThreshold` | Success threshold for readinessProbe | `1` |
| `startupProbe.enabled` | Enable startupProbe on MinIO containers | `true` |
| `startupProbe.initialDelaySeconds` | Initial delay seconds for startupProbe | `10` |
| `startupProbe.periodSeconds` | Period seconds for startupProbe | `10` |
| `startupProbe.timeoutSeconds` | Timeout seconds for startupProbe | `5` |
| `startupProbe.failureThreshold` | Failure threshold for startupProbe | `30` |
| `startupProbe.successThreshold` | Success threshold for startupProbe | `1` |

### Node Selection

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Toleration labels for pod assignment | `[]` |
| `affinity` | Affinity settings for pod assignment | `{}` |

## Examples

### Basic Deployment

Deploy MinIO with default configuration:

```bash
helm install my-minio ./charts/minio
```

### Production Setup with Persistence

```yaml
# values-production.yaml
persistence:
  enabled: true
  storageClass: "fast-ssd"
  size: 100Gi

resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "1000m"

auth:
  rootUser: "minio-admin"
  rootPassword: "your-secure-password"

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: minio.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: minio-tls
      hosts:
        - minio.yourdomain.com

consoleIngress:
  enabled: true
  className: "nginx"
  hosts:
    - host: minio-console.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: minio-console-tls
      hosts:
        - minio-console.yourdomain.com
```

Deploy with production values:

```bash
helm install my-minio ./charts/minio -f values-production.yaml
```

### High Availability Configuration

```yaml
# values-ha.yaml
replicaCount: 3

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
            - minio
        topologyKey: kubernetes.io/hostname

resources:
  requests:
    memory: "2Gi"
    cpu: "1000m"
  limits:
    memory: "4Gi"
```

### Using Existing Secret for Credentials

```yaml
# values-external-secret.yaml
auth:
  existingSecret: "minio-credentials"
  existingSecretUserKey: "username"
  existingSecretPasswordKey: "password"
```

Create the secret first:

```bash
kubectl create secret generic minio-credentials \
  --from-literal=username=minio-admin \
  --from-literal=password=your-secure-password
```

## Access MinIO

### Via kubectl port-forward

```bash
# Access MinIO API
kubectl port-forward service/my-minio 9000:9000

# Access MinIO Console
kubectl port-forward service/my-minio-console 9090:9090
```

### Default Credentials

- **Username**: `admin` (or value from `auth.rootUser`)
- **Password**: Check secret for auto-generated password or use configured value

Get the auto-generated password:

```bash
kubectl get secret my-minio -o jsonpath="{.data.root-password}" | base64 --decode
```

## Troubleshooting

### Common Issues

1. **Pod fails to start with permission errors**
   - Ensure your storage class supports the required access modes
   - Check if security contexts are compatible with your cluster policies

2. **Cannot access MinIO console**
   - Verify the console service is running: `kubectl get svc`
   - Check if ingress is properly configured
   - Ensure firewall rules allow access to port 9090

3. **Persistent volume not mounting**
   - Verify storage class exists: `kubectl get storageclass`
   - Check PVC status: `kubectl get pvc`
   - Review pod events: `kubectl describe pod <pod-name>`

### Getting Support

For issues related to this Helm chart, please check:
- [MinIO Documentation](https://docs.min.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- Chart repository issues
