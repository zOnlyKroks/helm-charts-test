<p align="center">
    <a href="https://artifacthub.io/packages/search?repo=cloudpirates-nginx"><img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/cloudpirates-nginx" /></a>
</p>

# Nginx

nginx ("engine x") is an HTTP web server, reverse proxy, content cache, load balancer, TCP/UDP proxy server, and mail proxy server. 

## Installing the Chart

To install the chart with the release name `my-nginx`:

```bash
helm install my-nginx oci://registry-1.docker.io/cloudpirates/nginx
```

To install with custom values:

```bash
helm install my-nginx oci://registry-1.docker.io/cloudpirates/nginx -f my-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `my-nginx` deployment:

```bash
helm uninstall my-nginx
```

This removes all the Kubernetes components associated with the chart and deletes the release.

## Security & Signature Verification

This Helm chart is cryptographically signed with Cosign to ensure authenticity and prevent tampering.

**Public Key:**

```
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE7BgqFgKdPtHdXz6OfYBklYwJgGWQ
mZzYz8qJ9r6QhF3NxK8rD2oG7Bk6nHJz7qWXhQoU2JvJdI3Zx9HGpLfKvw==
-----END PUBLIC KEY-----
```

To verify the helm chart before installation, copy the public key to the file `cosign.pub` and run cosign:

```bash
cosign verify --key cosign.pub registry-1.docker.io/cloudpirates/nginx:<version>
```

## Configuration

The following table lists the configurable parameters of the Nginx chart and their default values.

### Global Parameters

| Parameter                 | Description                                     | Default |
| ------------------------- | ----------------------------------------------- | ------- |
| `global.imageRegistry`    | Global Docker Image registry                    | `""`    |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`    |

### Common Parameters

| Parameter           | Description                                     | Default |
| ------------------- | ----------------------------------------------- | ------- |
| `nameOverride`      | String to partially override nginx.fullname     | `""`    |
| `fullnameOverride`  | String to fully override nginx.fullname         | `""`    |
| `commonLabels`      | Labels to add to all deployed objects           | `{}`    |
| `commonAnnotations` | Annotations to add to all deployed objects      | `{}`    |

### Nginx Image Parameters

| Parameter           | Description                                          | Default                                                                            |
| ------------------- | ---------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `image.registry`    | Nginx image registry                                 | `docker.io`                                                                        |
| `image.repository`  | Nginx image repository                               | `nginx`                                                                            |
| `image.tag`         | Nginx image tag (immutable tags are recommended)     | `"1.28.0@sha256:24ccf9a6192d2c6c5c4a6e9d2fdfa2a8e382b15f8dd7d0e05a1579f6a46f7776"` |
| `image.pullPolicy`  | Nginx image pull policy                              | `Always`                                                                           |
| `image.pullSecrets` | Nginx image pull secrets                             | `[]`                                                                               |

### Nginx Configuration Parameters

| Parameter               | Description                                    | Default |
| ----------------------- | ---------------------------------------------- | ------- |
| `config.memoryLimit`    | Maximum amount of memory to use for cache (MB) | `64`    |
| `config.maxConnections` | Maximum number of simultaneous connections     | `1024`  |
| `config.verbosity`      | Verbosity level (0-2)                          | `0`     |
| `config.extraArgs`      | Additional command-line arguments              | `[]`    |

### Service Parameters

| Parameter             | Description                                         | Default     |
| --------------------- | --------------------------------------------------- | ----------- |
| `service.type`        | Nginx service type                                  | `ClusterIP` |
| `service.port`        | Nginx service port                                  | `8080`       |
| `service.nodePort`    | Node port for Nginx service                         | `""`        |
| `service.clusterIP`   | Static cluster IP or "None" for headless service    | `""`        |
| `service.annotations` | Additional custom annotations for Nginx service     | `{}`        |

### Security Context Parameters

| Parameter                                           | Description                                             | Default |
| --------------------------------------------------- | ------------------------------------------------------- | ------- |
| `podSecurityContext.enabled`                        | Enabled pod Security Context                            | `true`  |
| `podSecurityContext.fsGroup`                        | Set Nginx pod's Security Context fsGroup                | `8080` |
| `containerSecurityContext.enabled`                  | Enabled Nginx container's Security Context              | `true`  |
| `containerSecurityContext.runAsUser`                | Set Nginx container's Security Context runAsUser        | `8080` |
| `containerSecurityContext.runAsNonRoot`             | Set Nginx container's Security Context runAsNonRoot     | `true`  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Nginx container's privilege escalation              | `false` |

### Resources Parameters

| Parameter            | Description                                          | Default                        |
| -------------------- | ---------------------------------------------------- | ------------------------------ |
| `resources.limits`   | The resources limits for the Nginx containers        | `{memory: "128Mi"}`            |
| `resources.requests` | The requested resources for the Nginx containers     | `{cpu: "50m", memory: "64Mi"}` |

### Health Check Parameters

| Parameter                            | Description                                   | Default |
| ------------------------------------ | --------------------------------------------- | ------- |
| `livenessProbe.enabled`              | Enable livenessProbe on Nginx containers      | `true`  |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe       | `30`    |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe              | `10`    |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe             | `5`     |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe           | `3`     |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe           | `1`     |
| `readinessProbe.enabled`             | Enable readinessProbe on Nginx containers     | `true`  |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe      | `5`     |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe             | `5`     |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe            | `5`     |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe          | `3`     |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe          | `1`     |

### Service Account Parameters

| Parameter                                     | Description                                           | Default |
| --------------------------------------------- | ----------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a service account should be created | `true`  |
| `serviceAccount.annotations`                  | Annotations to add to the service account             | `{}`    |
| `serviceAccount.name`                         | The name of the service account to use                | `""`    |
| `serviceAccount.automountServiceAccountToken` | Automatically mount service account token             | `false` |

### ConfigMap Parameters

| Parameter          | Description                                    | Default |
| ------------------ | ---------------------------------------------- | ------- |
| `configMap.create` | Create a ConfigMap for Nginx configuration     | `false` |
| `configMap.data`   | ConfigMap data                                 | `{}`    |

### Ingress Parameters

| Parameter             | Description                                                                   | Default                                                                                         |
| --------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `ingress.enabled`     | Enable ingress record generation for Nginx                                    | `false`                                                                                         |
| `ingress.className`   | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) | `""`                                                                                            |
| `ingress.annotations` | Additional annotations for the Ingress resource                               | `{}`                                                                                            |
| `ingress.hosts`       | An array with hosts and paths                                                 | `[{"host": "nginx.local", "paths": [{"path": "/", "pathType": "ImplementationSpecific"}]}]` |
| `ingress.tls`         | TLS configuration for the Ingress                                             | `[]`                                                                                            |

### Extra Configuration Parameters

| Parameter           | Description                                                                         | Default |
| ------------------- | ----------------------------------------------------------------------------------- | ------- |
| `extraEnv`          | A list of additional environment variables                                          | `[]`    |
| `extraVolumes`      | A list of additional existing volumes that will be mounted into the container       | `[]`    |
| `extraVolumeMounts` | A list of additional existing volume mounts that will be mounted into the container | `[]`    |
| `extraObjects`      | A list of additional Kubernetes objects to deploy alongside the release             | `[]`    |

#### Extra Objects

You can use the `extraObjects` array to deploy additional Kubernetes resources (such as NetworkPolicies, ConfigMaps, etc.) alongside the release. This is useful for customizing your deployment with extra manifests that are not covered by the default chart options.

**Helm templating is supported in any field, but all template expressions must be quoted.** For example, to use the release namespace, write `namespace: "{{ .Release.Namespace }}"`.

**Example: Deploy a NetworkPolicy with templating**

```yaml
extraObjects:
  - apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: allow-dns
      namespace: "{{ .Release.Namespace }}"
    spec:
      podSelector: {}
      policyTypes:
        - Egress
      egress:
        - to:
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: kube-system
              podSelector:
                matchLabels:
                  k8s-app: kube-dns
        - ports:
            - port: 53
              protocol: UDP
            - port: 53
              protocol: TCP
```

All objects in `extraObjects` will be rendered and deployed with the release. You can use any valid Kubernetes manifest, and reference Helm values or built-in objects as needed (just remember to quote template expressions).

### Pod Configuration Parameters

| Parameter        | Description                    | Default |
| ---------------- | ------------------------------ | ------- |
| `podAnnotations` | Additional pod annotations     | `{}`    |
| `podLabels`      | Additional pod labels          | `{}`    |
| `nodeSelector`   | Node labels for pod assignment | `{}`    |
| `tolerations`    | Tolerations for pod assignment | `[]`    |
| `affinity`       | Affinity for pod assignment    | `{}`    |

## Examples

### Basic Installation

Create a `values.yaml` file:

```yaml
config:
  memoryLimit: 128
  maxConnections: 2048

resources:
  limits:
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

Install the chart:

```bash
helm install my-nginx charts/nginx -f values.yaml
```

### Production Setup

```yaml
replicaCount: 3

config:
  memoryLimit: 512
  maxConnections: 4096
  verbosity: 1

resources:
  limits:
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi

service:
  type: ClusterIP

# Use anti-affinity to spread pods across nodes
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
                  - nginx
          topologyKey: kubernetes.io/hostname
```

### Custom Configuration with ConfigMap

```yaml
configMap:
  create: true
  data:
    nginx.conf: |
      -m 256
      -c 2048
      -v

config:
  extraArgs:
    - "-o"
    - "modern"
```

### With Service Account

```yaml
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/nginx-role
```

## Troubleshooting

### Connection Issues

1. **Check deployment and service status**:

   ```bash
   kubectl get deployment -l app.kubernetes.io/name=nginx
   kubectl get svc -l app.kubernetes.io/name=nginx
   kubectl get pods -l app.kubernetes.io/name=nginx
   ```
2. **Check pod logs**:

   ```bash
   kubectl logs <pod-name>
   ```

### Performance Tuning

For production workloads, consider:

- Using a dedicated ConfigMap for Nginx configuration
- Implementing rate limiting and connection throttling
- Enabling gzip compression for responses
- Monitoring performance metrics with Prometheus

## Links

- [Nginx Official Documentation](https://nginx.org/)
- [Nginx Docker Hub](https://hub.docker.com/_/nginx)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
