{{/*
Expand the name of the chart.
*/}}
{{- define "minio.name" -}}
{{- include "common.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "minio.fullname" -}}
{{- include "common.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "minio.chart" -}}
{{- include "common.chart" . -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "minio.labels" -}}
{{- include "common.labels" . -}}
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
{{- include "common.selectorLabels" . -}}
{{- end }}

{{/*
Return the proper MinIO image name
*/}}
{{- define "minio.image" -}}
{{- include "common.image" (dict "image" .Values.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" .) }}
{{- end -}}

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
Return MinIO server URL args
*/}}
{{- define "minio.serverUrl" -}}
{{- if .Values.config.serverUrl -}}
{{- printf "--console-address :%d --address :%d" (int .Values.service.consoleTargetPort) (int .Values.service.targetPort) -}}
{{- else -}}
{{- printf "--console-address :%d --address :%d" (int .Values.service.consoleTargetPort) (int .Values.service.targetPort) -}}
{{- end -}}
{{- end }}