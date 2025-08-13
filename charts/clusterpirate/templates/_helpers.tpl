{{/*
Expand the name of the chart.
*/}}
{{- define "clusterpirate.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clusterpirate.fullname" -}}
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
common.labels
*/}}
{{- define "clusterpirate.labels" }}
{{- $root := .}}
{{- range $key, $value := .Values.commonLabels}}
{{ $key }}: {{ toYaml $value | quote }}
{{- end}}
{{- end}}

{{/*
common.annotations
*/}}
{{- define "clusterpirate.annotations" }}
{{- $root := .}}
{{- range $key, $value := .Values.commonAnnotations}}
{{ $key }}: {{ toYaml $value | quote }}
{{- end}}
{{- end}}

{{/*
common.matchLabels
*/}}
{{- define "clusterpirate.matchLabels"}}
app: {{ template "clusterpirate.name" . }}
release: {{ .Release.Name }}
{{- end}}

{{- define "clusterpirate.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{- default (include "clusterpirate.fullname" .) (print .Values.serviceAccount.name) -}}
    {{- else -}}
        {{- default "default" (print .Values.serviceAccount.name) -}}
    {{- end -}}
{{- end -}}

{{/*
Return the proper ClusterPirate image name with both tag and digest when available
*/}}
{{- define "clusterpirate.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- $digest := .Values.image.digest -}}
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