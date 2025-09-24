<p align="center">
    <a href="https://artifacthub.io/packages/search?repo=cloudpirates-minio"><img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/cloudpirates-minio" /></a>
</p>

# MinIO

A Helm chart for MinIO - High Performance Object Storage compatible with Amazon S3 APIs. MinIO is a high-performance, distributed object storage server designed for large-scale data infrastructure.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-minio`:

```bash
helm install my-minio oci://registry-1.docker.io/cloudpirates/minio
```

To install with custom values:

```bash
helm install my-minio oci://registry-1.docker.io/cloudpirates/minio -f my-values.yaml
```

Or install directly from the local chart:

```bash
helm install my-minio ./charts/minio
```

The command deploys MinIO on the Kubernetes cluster in the default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-minio` deployment:

```bash
helm uninstall my-minio
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

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
cosign verify --key cosign.pub registry-1.docker.io/cloudpirates/minio:<version>
```

## Configuration


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth.existingSecret | string | `""` |  |
| auth.existingSecretPasswordKey | string | `"password"` |  |
| auth.existingSecretUserKey | string | `"user"` |  |
| auth.rootPassword | string | `""` |  |
| auth.rootUser | string | `"admin"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| config.browserEnabled | bool | `true` |  |
| config.domain | string | `""` |  |
| config.extraEnvVars | list | `[]` |  |
| config.region | string | `""` |  |
| config.serverUrl | string | `""` |  |
| consoleIngress.annotations | object | `{}` |  |
| consoleIngress.className | string | `""` |  |
| consoleIngress.enabled | bool | `false` |  |
| consoleIngress.hosts[0].host | string | `"minio-console.local"` |  |
| consoleIngress.hosts[0].paths[0].path | string | `"/"` |  |
| consoleIngress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| consoleIngress.tls | list | `[]` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| image.imagePullPolicy | string | `"Always"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"minio/minio"` |  |
| image.tag | string | `"RELEASE.2025-09-07T16-13-09Z@sha256:14cea493d9a34af32f524e538b8346cf79f3321eff8e708c1e2960462bd8936e"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"minio.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.mountPath | string | `"/mnt/data"` |  |
| persistence.size | string | `"8Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1001` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1001` |  |
| service.annotations | object | `{}` |  |
| service.consolePort | int | `9090` |  |
| service.port | int | `9000` |  |
| service.type | string | `"ClusterIP"` |  |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tolerations | list | `[]` |  |


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

### Exposing a Bucket Publicly (“CDN Server” Setup)

You can make a MinIO bucket publicly accessible (e.g. as a CDN endpoint) using Ingress and MinIO's CLI tool (`mc`). Below is an example configuration 
and the commands needed to set this up.

#### 1. Install the Helm Chart with Public Ingress

Ensure the **Ingress controller** (like [ingress-nginx](https://kubernetes.github.io/ingress-nginx/)) is deployed in your cluster.

Example `values.yaml` snippet for Helm install (replace `cdn.my-domain.local` and `my-bucket-name` with your own values):

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    # Uncomment if using cert-manager for TLS certificates
    # kubernetes.io/tls-acme: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /my-bucket-name/$1
    nginx.ingress.kubernetes.io/use-regex: "true"
  hosts:
    - host: cdn.my-domain.local
      paths:
        - path: /(.*)
          pathType: ImplementationSpecific
  # Uncomment and configure for TLS
  # tls:
  #   - secretName: minio-ingress-tls
  #     hosts:
  #       - cdn.my-domain.local
```

Install or upgrade the chart with:

```bash
helm install my-minio <chart> -f values.yaml
# Or, if upgrading:
# helm upgrade my-minio <chart> -f values.yaml
```

#### 2. Configure Your Bucket for Public Access

You need the [MinIO Client (`mc`)](https://min.io/docs/minio/linux/reference/minio-mc.html) to manage bucket policies. You can access `mc` directly in the MinIO pod:

```bash
kubectl exec -it -n <NAMESPACE> <MINIO_POD_NAME> -- bash
```

Inside the pod, configure as follows (replace `my-bucket-name` as needed):

1. **Set up access alias** (for local MinIO within pod):

    ```bash
    mc alias set local http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD
    ```

2. **Create your bucket** (skip if already exists):

    ```bash
    mc mb local/my-bucket-name
    ```

3. Create a custom policy in `/tmp/policy.json` to only allow `GetObject`, alternatively use the predefined `download` policy:
    ```bash
    echo '
    {
      "Statement": [
        {
        "Action": [
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Principal": {
          "AWS": [
          "*"
          ]
        },
        "Resource": [
          "arn:aws:s3:::my-bucket-name/*"
        ]
        }
      ],
      "Version": "2012-10-17"
    }' > /tmp/policy.yaml
    ```
4. **Set bucket policy**:

    ```bash
    # Set to download (allow get and list objects)
    mc anonymous set download local/my-bucket-name

    # Set to custom policy (allow only get objects)
    mc anonymous set-json /tmp/policy.json local/my-bucket-name
    ```

**Summary:**  
After these steps, your bucket (`my-bucket-name`) will be accessible via `https://cdn.my-domain.local/<object>` (if using TLS), and is publicly readable.


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
