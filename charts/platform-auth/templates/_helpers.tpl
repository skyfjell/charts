{{/*
Expand the name of the chart.
*/}}
{{- define "platform-auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "platform-auth.helper.codecentricName" -}}
{{ printf "%s-codecentric" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-auth.helper.traefikName" -}}
{{ printf "%s-traefik" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-auth.helper.keycloakName" -}}
{{ printf "%s-keycloak" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-auth.helper.bitnamiName" -}}
{{ printf "%s-bitnami" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-auth.helper.postgresName" -}}
{{ printf "%s-keycloak-storage" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-auth.fullname" -}}
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
{{- define "platform-auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-auth.labels" -}}
helm.sh/chart: {{ include "platform-auth.chart" . }}
{{ include "platform-auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platform-auth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platform-auth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "keycloak.dnsQuery" }}
name: JAVA_OPTS_APPEND
value: >-
  -XX:+UseContainerSupport
  -XX:MaxRAMPercentage=50.0
  -Djava.awt.headless=true
  -Djgroups.dns.query=keycloak-headless
{{- end }}

{{- define "keycloak.adminUser" }}
{{- if or .Values.keycloak.admin.username .Values.keycloak.admin.usernameSecretRef }}
name: KEYCLOAK_ADMIN
{{- if .Values.keycloak.admin.username }}
value: {{ .Values.keycloak.admin.username | quote}}
{{- else if .Values.keycloak.admin.usernameSecretRef }}
valueFrom:
  secretKeyRef:
    {{- with .Values.keycloak.admin.usernameSecretRef }}
    {{ toYaml . | nindent 8}}
    {{- end}}
  {{- end }}
{{- end }}
{{- end }}

{{- define "keycloak.adminPassword" }}
{{- if or .Values.keycloak.admin.password .Values.keycloak.admin.passwordSecretRef }}
name: KEYCLOAK_ADMIN_PASSWORD
{{- if .Values.keycloak.admin.password }}
value: {{ .Values.keycloak.admin.password | quote}}
{{- else if .Values.keycloak.admin.passwordSecretRef }}
valueFrom:
  secretKeyRef:
    {{- with .Values.keycloak.admin.passwordSecretRef }}
    {{ toYaml . | nindent 8}}
    {{- end}}
{{- end }}
{{- end }}
{{- end }}


{{- define "keycloak.extraEnv" }}
{{- $extraEnv := concat (list (include "keycloak.dnsQuery" . | fromYaml))  (default list .Values.keycloak.release.values.extraEnv ) }}
{{- with (include "keycloak.adminUser" . | fromYaml ) }}
{{- $extraEnv = concat (list .) $extraEnv}}
{{- end }}
{{- with (include "keycloak.adminPassword" . | fromYaml ) }}
{{- $extraEnv = concat (list .) $extraEnv}}
{{- end }}
{{- toYaml (default list $extraEnv | uniq) | nindent 6 }}
{{- end }}

{{- define "keycloak.Values" }}
{{- $values := omit .Values.keycloak.release.values "nodeSelector" "tolerations" "extraEnv" }}
{{- toYaml $values | nindent 4 }}
{{- end }}