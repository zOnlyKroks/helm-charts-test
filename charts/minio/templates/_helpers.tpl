{{/*
Expand the name of the chart.
*/}}
{{- define "minio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "minio.fullname" -}}
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
{{- define "minio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "minio.labels" -}}
helm.sh/chart: {{ include "minio.chart" . }}
{{ include "minio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "minio.annotations" -}}
{{- with .Values.commonAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "minio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "minio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper MinIO image name with both tag and digest when available
*/}}
{{- define "minio.image" -}}
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
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end }}

{{/*
Return MinIO credentials secret name
*/}}
{{- define "minio.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- .Values.auth.existingSecret -}}
{{- else -}}
    {{- include "minio.fullname" . -}}
{{- end -}}
{{- end }}

{{/*
Return MinIO root user
*/}}
{{- define "minio.rootUser" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" .Values.auth.existingSecretUserKey -}}
{{- else -}}
root-user
{{- end -}}
{{- end }}

{{/*
Return MinIO root password
*/}}
{{- define "minio.rootPasswordKey" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" .Values.auth.existingSecretPasswordKey -}}
{{- else -}}
root-password
{{- end -}}
{{- end }}

{{/*
Return MinIO data directory
*/}}
{{- define "minio.dataDir" -}}
{{- printf "/data" -}}
{{- end }}

{{/*
Return MinIO server URL args
*/}}
{{- define "minio.serverUrl" -}}
{{- if .Values.config.serverUrl -}}
{{- printf "--console-address :9090 --address :9000" -}}
{{- else -}}
{{- printf "--console-address :9090 --address :9000" -}}
{{- end -}}
{{- end }}