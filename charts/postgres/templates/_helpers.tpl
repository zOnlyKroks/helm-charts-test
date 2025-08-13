{{/*
Expand the name of the chart.
*/}}
{{- define "postgres.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgres.fullname" -}}
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
{{- define "postgres.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgres.labels" -}}
helm.sh/chart: {{ include "postgres.chart" . }}
{{ include "postgres.selectorLabels" . }}
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
{{- define "postgres.annotations" -}}
{{- with .Values.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "postgres.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $separator := ":" -}}
{{- $termination := .Values.image.tag | toString -}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- $registryName = .Values.global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if .Values.image.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .Values.image.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s" $repositoryName $separator $termination -}}
{{- end -}}
{{- end }}

{{/*
Return PostgreSQL credentials secret name
*/}}
{{- define "postgres.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- .Values.auth.existingSecret -}}
{{- else -}}
    {{- include "postgres.fullname" . -}}
{{- end -}}
{{- end }}

{{/*
Return PostgreSQL admin password key
*/}}
{{- define "postgres.adminPasswordKey" -}}
{{- if .Values.auth.existingSecret -}}
    {{- .Values.auth.secretKeys.adminPasswordKey -}}
{{- else -}}
postgres-password
{{- end -}}
{{- end }}

{{/*
Return PostgreSQL user password key
*/}}
{{- define "postgres.userPasswordKey" -}}
{{- if .Values.auth.existingSecret -}}
    {{- .Values.auth.secretKeys.userPasswordKey -}}
{{- else -}}
password
{{- end -}}
{{- end }}

{{/*
Return PostgreSQL configuration ConfigMap name
*/}}
{{- define "postgres.configmapName" -}}
{{- if .Values.config.existingConfigmap -}}
    {{- .Values.config.existingConfigmap -}}
{{- else -}}
    {{- include "postgres.fullname" . -}}
{{- end -}}
{{- end }}

{{/*
Return PostgreSQL data directory
*/}}
{{- define "postgres.dataDir" -}}
{{- printf "/var/lib/postgresql/data" -}}
{{- end }}

{{/*
Return PostgreSQL config directory
*/}}
{{- define "postgres.configDir" -}}
{{- printf "/etc/postgresql" -}}
{{- end }}

{{/*
Return PostgreSQL run directory
*/}}
{{- define "postgres.runDir" -}}
{{- printf "/var/run/postgresql" -}}
{{- end }}

{{/*
Check if we should create a custom user
*/}}
{{- define "postgres.createUser" -}}
{{- if and .Values.auth.username .Values.auth.database -}}
true
{{- else -}}
false
{{- end -}}
{{- end }}

{{/*
Get PostgreSQL database name
*/}}
{{- define "postgres.database" -}}
{{- if .Values.auth.database -}}
{{- .Values.auth.database -}}
{{- else -}}
postgres
{{- end -}}
{{- end }}

{{/*
Get PostgreSQL username
*/}}
{{- define "postgres.username" -}}
{{- if .Values.auth.username -}}
{{- .Values.auth.username -}}
{{- else -}}
postgres
{{- end -}}
{{- end }}