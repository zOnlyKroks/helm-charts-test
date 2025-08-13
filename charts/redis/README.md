# Redis

A Helm chart for deploying Redis - an open source, in-memory data structure store used as a database, cache, and message broker.

## Installing the Chart

To install the chart with the release name `my-redis`:

```bash
$ helm repo add cloudpirates oci://registry-1.docker.io/cloudpirates
helm install my-redis cloudpirates/redis
```

The command deploys Redis on the Kubernetes cluster in the default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-redis` deployment:

```bash
helm uninstall my-redis
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

### Global parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `""` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` |
| `global.storageClass` | Global StorageClass for Persistent Volume(s) | `""` |

### Common parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kubeVersion` | Override Kubernetes version | `""` |
| `nameOverride` | String to partially override redis.fullname | `""` |
| `fullnameOverride` | String to fully override redis.fullname | `""` |
| `namespaceOverride` | String to fully override common.names.namespace | `""` |
| `commonLabels` | Labels to add to all deployed objects | `{}` |
| `commonAnnotations` | Annotations to add to all deployed objects | `{}` |

### Redis Image parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.registry` | Redis image registry | `docker.io` |
| `image.repository` | Redis image repository | `redis` |
| `image.tag` | Redis image tag | `"7.2.4"` |
| `image.digest` | Redis image digest | `""` |
| `image.pullPolicy` | Redis image pull policy | `IfNotPresent` |
| `image.pullSecrets` | Redis image pull secrets | `[]` |

### Redis Configuration parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `architecture` | Redis architecture (`standalone` or `replication`) | `standalone` |
| `auth.enabled` | Enable password authentication | `true` |
| `auth.password` | Redis password | `""` |
| `auth.existingSecret` | The name of an existing secret with Redis credentials | `""` |
| `auth.existingSecretPasswordKey` | Password key to be retrieved from existing secret | `""` |
| `auth.usePasswordFiles` | Mount credentials as files instead of using an environment variable | `false` |
| `commonConfiguration` | Redis common configuration to be added into the ConfigMap | `appendonly yes\nsave ""` |

### Redis master configuration parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `master.count` | Number of Redis master instances to deploy | `1` |
| `master.configuration` | Configuration for Redis master nodes | `""` |
| `master.disableCommands` | Array with Redis commands to disable on master nodes | `["FLUSHDB", "FLUSHALL"]` |
| `master.command` | Override default container command | `[]` |
| `master.args` | Override default container args | `[]` |
| `master.enableServiceLinks` | Whether information about services should be injected into pod's environment variable | `true` |
| `master.preExecCmds` | Additional commands to run prior to starting Redis master | `[]` |
| `master.extraFlags` | Array with additional command line flags for Redis master | `[]` |
| `master.extraEnvVars` | Array with extra environment variables to add to Redis master nodes | `[]` |
| `master.extraEnvVarsCM` | Name of existing ConfigMap containing extra env vars for Redis master nodes | `""` |
| `master.extraEnvVarsSecret` | Name of existing Secret containing extra env vars for Redis master nodes | `""` |
| `master.containerPorts.redis` | Container port to open on Redis master nodes | `6379` |

### Health checks

| Parameter | Description | Default |
|-----------|-------------|---------|
| `master.startupProbe.enabled` | Enable startupProbe on Redis master nodes | `false` |
| `master.startupProbe.initialDelaySeconds` | Initial delay seconds for startupProbe | `20` |
| `master.startupProbe.periodSeconds` | Period seconds for startupProbe | `5` |
| `master.startupProbe.timeoutSeconds` | Timeout seconds for startupProbe | `5` |
| `master.startupProbe.failureThreshold` | Failure threshold for startupProbe | `5` |
| `master.startupProbe.successThreshold` | Success threshold for startupProbe | `1` |
| `master.livenessProbe.enabled` | Enable livenessProbe on Redis master nodes | `true` |
| `master.livenessProbe.initialDelaySeconds` | Initial delay seconds for livenessProbe | `20` |
| `master.livenessProbe.periodSeconds` | Period seconds for livenessProbe | `5` |
| `master.livenessProbe.timeoutSeconds` | Timeout seconds for livenessProbe | `5` |
| `master.livenessProbe.failureThreshold` | Failure threshold for livenessProbe | `5` |
| `master.livenessProbe.successThreshold` | Success threshold for livenessProbe | `1` |
| `master.readinessProbe.enabled` | Enable readinessProbe on Redis master nodes | `true` |
| `master.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe | `5` |
| `master.readinessProbe.periodSeconds` | Period seconds for readinessProbe | `5` |
| `master.readinessProbe.timeoutSeconds` | Timeout seconds for readinessProbe | `1` |
| `master.readinessProbe.failureThreshold` | Failure threshold for readinessProbe | `5` |
| `master.readinessProbe.successThreshold` | Success threshold for readinessProbe | `1` |

### Resources

| Parameter | Description | Default |
|-----------|-------------|---------|
| `master.resources.limits` | The resources limits for the Redis master containers | `{}` |
| `master.resources.requests` | The requested resources for the Redis master containers | `{}` |

### Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `master.podSecurityContext.enabled` | Enabled Redis master pods' Security Context | `true` |
| `master.podSecurityContext.fsGroup` | Set Redis master pod's Security Context fsGroup | `1001` |
| `master.containerSecurityContext.enabled` | Enabled Redis master containers' Security Context | `true` |
| `master.containerSecurityContext.runAsUser` | Set Redis master containers' Security Context runAsUser | `1001` |
| `master.containerSecurityContext.runAsNonRoot` | Set Redis master containers' Security Context runAsNonRoot | `true` |

### Deployment parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `master.kind` | Use either Deployment or StatefulSet | `StatefulSet` |
| `master.schedulerName` | Alternate scheduler for Redis master pods | `""` |
| `master.updateStrategy.type` | Redis master statefulset strategy type | `RollingUpdate` |
| `master.priorityClassName` | Redis master pods' priorityClassName | `""` |
| `master.hostAliases` | Redis master pods host aliases | `[]` |
| `master.podLabels` | Extra labels for Redis master pods | `{}` |
| `master.podAnnotations` | Annotations for Redis master pods | `{}` |
| `master.shareProcessNamespace` | Share a single process namespace between all containers | `false` |
| `master.podAffinityPreset` | Pod affinity preset | `""` |
| `master.podAntiAffinityPreset` | Pod anti-affinity preset | `soft` |
| `master.nodeAffinityPreset.type` | Node affinity preset type | `""` |
| `master.nodeAffinityPreset.key` | Node label key to match | `""` |
| `master.nodeAffinityPreset.values` | Node label values to match | `[]` |
| `master.affinity` | Affinity for Redis master pods assignment | `{}` |
| `master.nodeSelector` | Node labels for Redis master pods assignment | `{}` |
| `master.tolerations` | Tolerations for Redis master pods assignment | `[]` |
| `master.topologySpreadConstraints` | Spread Constraints for Redis master pod assignment | `[]` |

### Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `master.persistence.enabled` | Enable persistence on Redis master nodes using Persistent Volume Claims | `true` |
| `master.persistence.medium` | Provide a medium for `emptyDir` volumes | `""` |
| `master.persistence.sizeLimit` | Set this to enable a size limit for `emptyDir` volumes | `""` |
| `master.persistence.path` | The path the volume will be mounted at on Redis master containers | `/data` |
| `master.persistence.subPath` | The subdirectory of the volume to mount on Redis master containers | `""` |
| `master.persistence.subPathExpr` | Used to construct the subPath subdirectory of the volume to mount | `""` |
| `master.persistence.storageClass` | Persistent Volume storage class | `""` |
| `master.persistence.accessModes` | Persistent Volume access modes | `["ReadWriteOnce"]` |
| `master.persistence.size` | Persistent Volume size | `8Gi` |
| `master.persistence.annotations` | Additional custom annotations for the PVC | `{}` |
| `master.persistence.selector` | Additional labels to match for the PVC | `{}` |
| `master.persistence.dataSource` | Custom PVC data source | `{}` |
| `master.persistence.existingClaim` | Use a existing PVC which must be created manually before bound | `""` |

### Service parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Redis service type | `ClusterIP` |
| `service.ports.redis` | Redis service port | `6379` |
| `service.nodePorts.redis` | Node port for Redis | `""` |
| `service.externalTrafficPolicy` | Redis service external traffic policy | `Cluster` |
| `service.extraPorts` | Extra ports to expose | `[]` |
| `service.internalTrafficPolicy` | Redis service internal traffic policy | `Cluster` |
| `service.clusterIP` | Redis service Cluster IP | `""` |
| `service.loadBalancerIP` | Redis service Load Balancer IP | `""` |
| `service.loadBalancerSourceRanges` | Redis service Load Balancer sources | `[]` |
| `service.annotations` | Additional custom annotations for Redis service | `{}` |
| `service.sessionAffinity` | Control where client requests go | `None` |
| `service.sessionAffinityConfig` | Additional settings for the sessionAffinity | `{}` |

### Network Policy parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `networkPolicy.enabled` | Enable creation of NetworkPolicy resources | `false` |
| `networkPolicy.allowExternal` | The Policy model to apply | `true` |
| `networkPolicy.extraIngress` | Add extra ingress rules to the NetworkPolicy | `[]` |
| `networkPolicy.extraEgress` | Add extra ingress rules to the NetworkPolicy | `[]` |
| `networkPolicy.ingressNSMatchLabels` | Labels to match to allow traffic from other namespaces | `{}` |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces | `{}` |

### Ingress parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress record generation for Redis | `false` |
| `ingress.pathType` | Ingress path type | `ImplementationSpecific` |
| `ingress.apiVersion` | Force Ingress API version | `""` |
| `ingress.hostname` | Default host for the ingress record | `redis.local` |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress | `""` |
| `ingress.path` | Default path for the ingress record | `/` |
| `ingress.annotations` | Additional annotations for the Ingress resource | `{}` |
| `ingress.tls` | Enable TLS configuration for the host defined at `ingress.hostname` parameter | `false` |
| `ingress.selfSigned` | Create a TLS secret for this ingress record using self-signed certificates | `false` |
| `ingress.extraHosts` | An array with additional hostname(s) to be covered with the ingress record | `[]` |
| `ingress.extraPaths` | An array with additional arbitrary paths | `[]` |
| `ingress.extraTls` | TLS configuration for additional hostname(s) | `[]` |
| `ingress.secrets` | Custom TLS certificates as secrets | `[]` |
| `ingress.extraRules` | Additional rules to be covered with this ingress record | `[]` |

## Examples

### Basic deployment

```bash
helm install my-redis ./redis
```

### Production setup with persistence

```yaml
# values.yaml
auth:
  enabled: true
  password: "my-secret-password"

master:
  persistence:
    enabled: true
    size: 20Gi
    storageClass: "fast-ssd"

  resources:
    limits:
      memory: 2Gi
      cpu: 1000m
    requests:
      memory: 1Gi
      cpu: 500m

service:
  type: LoadBalancer
```

```bash
helm install my-redis ./redis -f values.yaml
```

### High availability configuration

```yaml
# values.yaml
master:
  count: 1
  kind: StatefulSet
  
  podAntiAffinityPreset: hard
  
  resources:
    limits:
      memory: 4Gi
      cpu: 2000m
    requests:
      memory: 2Gi
      cpu: 1000m

networkPolicy:
  enabled: true
```

```bash
helm install my-redis ./redis -f values.yaml
```

### Custom Redis configuration

```yaml
# values.yaml
commonConfiguration: |-
  # Enable AOF persistence
  appendonly yes
  appendfilename "appendonly.aof"
  
  # Memory management
  maxmemory 2gb
  maxmemory-policy allkeys-lru
  
  # Slow log
  slowlog-log-slower-than 10000
  slowlog-max-len 256

master:
  configuration: |-
    # Custom master configuration
    replica-read-only yes
    replica-serve-stale-data yes
```

```bash
helm install my-redis ./redis -f values.yaml
```

## Troubleshooting

### Connection Issues

1. Check if the Redis pod is running:
   ```bash
   kubectl get pods -l app.kubernetes.io/name=redis
   ```

2. Check Redis logs:
   ```bash
   kubectl logs -l app.kubernetes.io/name=redis
   ```

3. Test connection:
   ```bash
   kubectl run redis-client --rm -it --image redis:7.2.4 -- redis-cli -h <redis-service-name> -p 6379
   ```

### Authentication Issues

If you're having authentication problems:

1. Check if the secret exists:
   ```bash
   kubectl get secret <redis-secret-name>
   ```

2. Verify the password:
   ```bash
   kubectl get secret <redis-secret-name> -o jsonpath='{.data.redis-password}' | base64 -d
   ```

### Performance Issues

1. Check resource usage:
   ```bash
   kubectl top pods -l app.kubernetes.io/name=redis
   ```

2. Analyze Redis slow log:
   ```bash
   redis-cli -h <redis-service> -p 6379 slowlog get 10
   ```

## Links

- [Redis Official Documentation](https://redis.io/documentation)
- [Redis Docker Hub](https://hub.docker.com/_/redis)
- [Redis Configuration](https://redis.io/topics/config)