{{/*
Expand the name of the chart.
*/}}
{{- define "redis.name" -}}
{{- include "common.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
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
{{- include "common.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis.selectorLabels" -}}
{{- include "common.selectorLabels" . -}}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "redis.annotations" -}}
{{- include "common.annotations" . -}}
{{- end }}

{{/*
Get the secret name for Redis password
*/}}
{{- define "redis.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "redis.fullname" . }}
{{- end }}
{{- end }}

{{/*
Get the secret key for Redis password
*/}}
{{- define "redis.secretPasswordKey" -}}
{{- if .Values.auth.existingSecretPasswordKey }}
{{- .Values.auth.existingSecretPasswordKey }}
{{- else }}redis-password
{{- end }}
{{- end }}

{{/*
Return the proper Redis image name
*/}}
{{- define "redis.image" -}}
{{- include "common.image" (dict "image" .Values.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redis.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" .) }}
{{- end -}}

{{- define "redis.configFullName" -}}
{{- if and .Values.config.existingConfigmapKey .Values.config.existingConfigmap }}
{{- printf "%s/%s" .Values.config.mountPath .Values.config.existingConfigmapKey }}
{{- else }}
{{- printf "%s/redis.conf" .Values.config.mountPath }}
{{- end -}}
{{- end -}}