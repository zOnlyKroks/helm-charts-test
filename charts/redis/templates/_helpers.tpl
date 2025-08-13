{{/*
Expand the name of the chart.
*/}}
{{- define "redis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redis.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "redis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redis.labels" -}}
helm.sh/chart: {{ include "redis.chart" . }}
{{ include "redis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper Redis image name with both tag and digest when available
*/}}
{{- define "redis.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- $digest := .Values.image.digest -}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- $registryName = .Values.global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if $registryName }}
    {{- $repositoryName = printf "%s/%s" $registryName $repositoryName -}}
{{- end -}}
{{- if and $digest (ne $digest "") }}
    {{- if and $tag (ne $tag "") }}
        {{- printf "%s:%s@%s" $repositoryName $tag $digest -}}
    {{- else -}}
        {{- printf "%s@%s" $repositoryName $digest -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
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
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end }}

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