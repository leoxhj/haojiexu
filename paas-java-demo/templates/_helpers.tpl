{{/*
Expand the name of the chart.
*/}}
{{- define "paas-java-demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paas-java-demo.fullname" -}}
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
{{- define "paas-java-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "paas-java-demo.labels" -}}
helm.sh/chart: {{ include "paas-java-demo.chart" . }}
{{ include "paas-java-demo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "paas-java-demo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paas-java-demo.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "paas-java-demo.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled }}
{{- default (include "paas-java-demo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the tls secret for secure port
*/}}
{{- define "paas-java-demo.tlsSecretName" -}}
{{- $fullname := include "paas-java-demo.fullname" . -}}
{{- default (printf "%s-tls" $fullname) .Values.tls.secretName }}
{{- end }}