{{- define "javahelloworld.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "javahelloworld.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "javahelloworld.labels" -}}
helm.sh/chart: {{ include "javahelloworld.chart" . }}
{{ include "javahelloworld.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "javahelloworld.selectorLabels" -}}
app.kubernetes.io/name: {{ include "javahelloworld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "javahelloworld.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}