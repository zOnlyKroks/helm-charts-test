{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq.name" -}}
{{- include "common.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rabbitmq.fullname" -}}
{{- include "common.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rabbitmq.chart" -}}
{{- include "common.chart" . -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rabbitmq.labels" -}}
{{- include "common.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rabbitmq.selectorLabels" -}}
{{- include "common.selectorLabels" . -}}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "rabbitmq.annotations" -}}
{{- include "common.annotations" . -}}
{{- end }}

{{/*
Get the secret name for RabbitMQ credentials
*/}}
{{- define "rabbitmq.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "rabbitmq.fullname" . }}
{{- end }}
{{- end }}

{{/*
Get the secret key for RabbitMQ password
*/}}
{{- define "rabbitmq.secretPasswordKey" -}}
{{- if .Values.auth.existingPasswordKey }}
{{- .Values.auth.existingPasswordKey }}
{{- else }}password
{{- end }}
{{- end }}

{{/*
Get the secret key for Erlang cookie
*/}}
{{- define "rabbitmq.secretErlangCookieKey" -}}
{{- if .Values.auth.existingErlangCookieKey }}
{{- .Values.auth.existingErlangCookieKey }}
{{- else }}erlang-cookie
{{- end }}
{{- end }}

{{/*
Return the proper RabbitMQ image name
*/}}
{{- define "rabbitmq.image" -}}
{{- include "common.image" (dict "image" .Values.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "rabbitmq.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" .) }}
{{- end -}}

{{/*
Generate RabbitMQ hostname for clustering
*/}}
{{- define "rabbitmq.hostname" -}}
{{- if .Values.clustering.enabled }}
{{- printf "%s-${HOSTNAME##*-}.%s.%s.svc.cluster.local" (include "rabbitmq.fullname" .) (include "rabbitmq.fullname" .) .Release.Namespace }}
{{- else }}
{{- printf "%s.%s.svc.cluster.local" (include "rabbitmq.fullname" .) .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Generate RabbitMQ node name
*/}}
{{- define "rabbitmq.nodeName" -}}
{{- if .Values.clustering.enabled }}
rabbit@{{ include "rabbitmq.hostname" . }}
{{- else }}
rabbit@{{ include "rabbitmq.fullname" . }}
{{- end }}
{{- end }}

{{/*
Memory high watermark calculation
*/}}
{{- define "rabbitmq.memoryHighWatermark" -}}
{{- if eq .Values.config.memoryHighWatermarkType "relative" }}
{{- printf "%.2f" .Values.config.memoryHighWatermark }}
{{- else }}
{{- printf "%s" (.Values.config.memoryHighWatermark | toString) }}
{{- end }}
{{- end }}