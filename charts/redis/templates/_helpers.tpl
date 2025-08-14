{{/*
Expand the name of the chart.
*/}}
{{- define "redis.name" -}}
{{- include "common.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redis.fullname" -}}
{{- include "common.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "redis.chart" -}}
{{- include "common.chart" . -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redis.labels" -}}
{{- include "common.labels" . -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis.selectorLabels" -}}
{{- include "common.selectorLabels" . -}}
{{- end }}

{{/*
Return the proper Redis image name
*/}}
{{- define "redis.image" -}}
{{- include "common.image" (dict "image" .Values.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "redis.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end }}

{{/*
Return the proper Redis exporter image name
*/}}
{{- define "redis.exporter.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redis.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" .) }}
{{- end -}}

{{/*
Return the Redis configuration configmap
*/}}
{{- define "redis.configmapName" -}}
{{- printf "%s-configuration" (include "redis.fullname" .) }}
{{- end }}

{{/*
Return the Redis Secret Name
*/}}
{{- define "redis.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- printf "%s" (tpl .Values.auth.existingSecret $) }}
{{- else }}
{{- printf "%s" (include "redis.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Return the Redis Secret Key
*/}}
{{- define "redis.secretPasswordKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.existingSecretPasswordKey }}
{{- printf "%s" .Values.auth.existingSecretPasswordKey }}
{{- else }}
{{- printf "redis-password" }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "redis.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0" .Capabilities.KubeVersion.GitVersion }}
{{- print "networking.k8s.io/v1" }}
{{- else }}
{{- print "extensions/v1beta1" }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "redis.ingress.apiVersion" -}}
{{- if .Values.ingress.apiVersion }}
{{- .Values.ingress.apiVersion }}
{{- else }}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion }}
{{- print "networking.k8s.io/v1" }}
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion }}
{{- print "networking.k8s.io/v1beta1" }}
{{- else }}
{{- print "extensions/v1beta1" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "redis.ingress.createTlsSecret" -}}
{{- if and .Values.ingress.tls .Values.ingress.selfSigned }}
{{- true }}
{{- end }}
{{- end }}

{{/*
Return the path for the ingress
*/}}
{{- define "redis.ingress.path" -}}
{{- $pathType := .Values.ingress.pathType | default "ImplementationSpecific" }}
{{- if eq $pathType "Exact" }}
{{- .Values.ingress.path }}
{{- else }}
{{- .Values.ingress.path | default "/" }}
{{- end }}
{{- end }}

{{/*
Common image rendering function
*/}}
{{- define "common.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s"  $repositoryName $separator $termination -}}
{{- end -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names (deprecated: use common.images.pullSecrets)
*/}}
{{- define "common.images.pullSecrets" -}}
{{- $pullSecrets := list }}
{{- if .global }}
    {{- range .global.imagePullSecrets -}}
        {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
{{- end -}}
{{- range .images -}}
    {{- range .pullSecrets -}}
        {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
{{- range $pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return Redis master service name
*/}}
{{- define "redis.master.serviceName" -}}
{{- printf "%s-master" (include "redis.fullname" .) }}
{{- end }}

{{/*
Return Redis headless service name
*/}}
{{- define "redis.headlessServiceName" -}}
{{- printf "%s-headless" (include "redis.fullname" .) }}
{{- end }}

{{/*
Validate values of Redis - must provide a valid architecture
*/}}
{{- define "redis.validateValues.architecture" -}}
{{- if not (or (eq .Values.architecture "standalone") (eq .Values.architecture "replication")) }}
redis: .Values.architecture
    Invalid architecture selected. Valid values are "standalone" and
    "replication". Please set a valid architecture (--set architecture="standalone")
{{- end }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "redis.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "redis.validateValues.architecture" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end }}