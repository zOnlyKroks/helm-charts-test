{{/*
Expand the name of the chart.
*/}}
{{- define "mariadb.name" -}}
{{- include "common.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mariadb.fullname" -}}
{{- include "common.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mariadb.chart" -}}
{{- include "common.chart" . -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mariadb.labels" -}}
{{- include "common.labels" . -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mariadb.selectorLabels" -}}
{{- include "common.selectorLabels" . -}}
{{- end }}

{{/*
Return the proper MariaDB image name
*/}}
{{- define "mariadb.image" -}}
{{- include "common.image" (dict "image" .Values.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mariadb.imagePullSecrets" -}}
{{- $pullSecrets := list }}
{{- if .Values.global.imagePullSecrets }}
  {{- $pullSecrets = .Values.global.imagePullSecrets }}
{{- end }}
{{- if .Values.image.pullSecrets }}
  {{- $pullSecrets = append $pullSecrets .Values.image.pullSecrets }}
{{- end }}
{{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
{{- range $pullSecrets }}
{{- if kindIs "map" . }}
  - name: {{ .name }}
{{- else }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "mariadb.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "mariadb.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the MariaDB ConfigMap Name
*/}}
{{- define "mariadb.configMapName" -}}
{{- if .Values.config.existingConfigMap }}
{{- .Values.config.existingConfigMap }}
{{- else }}
{{- include "mariadb.fullname" . }}
{{- end }}
{{- end }}

{{/*
Validate MariaDB required passwords are not empty
*/}}
{{- define "mariadb.validateValues.auth" -}}
{{- if not .Values.auth.existingSecret -}}
  {{- if not .Values.auth.rootPassword -}}
mariadb: auth.rootPassword
    You must provide a password for MariaDB root user.
    Please set auth.rootPassword or use an existing secret.
  {{- end -}}
  {{- if and .Values.auth.username (not .Values.auth.password) -}}
mariadb: auth.password
    You must provide a password for the custom MariaDB user.
    Please set auth.password or use an existing secret.
  {{- end -}}
{{- end -}}
{{- end -}}

