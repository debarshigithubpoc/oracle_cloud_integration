{{- define "dotnethelloworld.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dotnethelloworld.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "dotnethelloworld.labels" -}}
helm.sh/chart: {{ include "dotnethelloworld.chart" . }}
{{ include "dotnethelloworld.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "dotnethelloworld.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dotnethelloworld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "dotnethelloworld.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}