{{/*
Expand the name of the chart.
*/}}
{{- define "justbenchthatllm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "justbenchthatllm.fullname" -}}
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
{{- define "justbenchthatllm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "justbenchthatllm.labels" -}}
helm.sh/chart: {{ include "justbenchthatllm.chart" . }}
{{ include "justbenchthatllm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.global.labels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "justbenchthatllm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "justbenchthatllm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "justbenchthatllm.annotations" -}}
{{- with .Values.global.annotations }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Redis labels
*/}}
{{- define "justbenchthatllm.redis.labels" -}}
{{ include "justbenchthatllm.labels" . }}
app.kubernetes.io/component: redis
{{- with .Values.redis.podLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Redis selector labels
*/}}
{{- define "justbenchthatllm.redis.selectorLabels" -}}
{{ include "justbenchthatllm.selectorLabels" . }}
app.kubernetes.io/component: redis
{{- end }}

{{/*
Redis annotations
*/}}
{{- define "justbenchthatllm.redis.annotations" -}}
{{ include "justbenchthatllm.annotations" . }}
{{- with .Values.redis.podAnnotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
MongoDB labels
*/}}
{{- define "justbenchthatllm.mongo.labels" -}}
{{ include "justbenchthatllm.labels" . }}
app.kubernetes.io/component: mongo
{{- with .Values.mongo.podLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
MongoDB selector labels
*/}}
{{- define "justbenchthatllm.mongo.selectorLabels" -}}
{{ include "justbenchthatllm.selectorLabels" . }}
app.kubernetes.io/component: mongo
{{- end }}

{{/*
MongoDB annotations
*/}}
{{- define "justbenchthatllm.mongo.annotations" -}}
{{ include "justbenchthatllm.annotations" . }}
{{- with .Values.mongo.podAnnotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Backend labels
*/}}
{{- define "justbenchthatllm.backend.labels" -}}
{{ include "justbenchthatllm.labels" . }}
app.kubernetes.io/component: backend
{{- with .Values.backend.podLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Backend selector labels
*/}}
{{- define "justbenchthatllm.backend.selectorLabels" -}}
{{ include "justbenchthatllm.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Backend annotations
*/}}
{{- define "justbenchthatllm.backend.annotations" -}}
{{ include "justbenchthatllm.annotations" . }}
{{- with .Values.backend.podAnnotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Worker labels
*/}}
{{- define "justbenchthatllm.worker.labels" -}}
{{ include "justbenchthatllm.labels" . }}
app.kubernetes.io/component: worker
{{- with .Values.worker.podLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Worker selector labels
*/}}
{{- define "justbenchthatllm.worker.selectorLabels" -}}
{{ include "justbenchthatllm.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end }}

{{/*
Worker annotations
*/}}
{{- define "justbenchthatllm.worker.annotations" -}}
{{ include "justbenchthatllm.annotations" . }}
{{- with .Values.worker.podAnnotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "justbenchthatllm.frontend.labels" -}}
{{ include "justbenchthatllm.labels" . }}
app.kubernetes.io/component: frontend
{{- with .Values.frontend.podLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "justbenchthatllm.frontend.selectorLabels" -}}
{{ include "justbenchthatllm.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Frontend annotations
*/}}
{{- define "justbenchthatllm.frontend.annotations" -}}
{{ include "justbenchthatllm.annotations" . }}
{{- with .Values.frontend.podAnnotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Redis connection URL
*/}}
{{- define "justbenchthatllm.redis.url" -}}
{{- printf "redis://%s-redis:%v/0" (include "justbenchthatllm.fullname" .) (int .Values.redis.service.port) }}
{{- end }}

{{/*
MongoDB connection URL
*/}}
{{- define "justbenchthatllm.mongo.url" -}}
{{- printf "mongodb://%s-mongo:%v" (include "justbenchthatllm.fullname" .) (int .Values.mongo.service.port) }}
{{- end }}

{{/*
Backend URL
*/}}
{{- define "justbenchthatllm.backend.url" -}}
{{- printf "http://%s-backend:%v" (include "justbenchthatllm.fullname" .) (int .Values.backend.service.port) }}
{{- end }}

