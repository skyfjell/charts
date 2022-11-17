{{/*
Expand the name of the chart.
*/}}
{{- define "platform-tenant.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-tenant.fullname" -}}
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
{{- define "platform-tenant.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-tenant.labels" -}}
helm.sh/chart: {{ include "platform-tenant.chart" . }}
{{ include "platform-tenant.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-tenant.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-tenant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platform-tenant.serviceAccount.name" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platform-tenant.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

# defaults for kustomization spec
{{- define "platform-tenant.kustomization.spec" -}}
interval: 1m0s
path: /
prune: true
validation: client
{{- end }}                                                                           

{{- define "platform-tenant.cluster-role.name" -}}
{{ (default (printf "%s-%s" .Release.Name "tenant") .Values.components.rbac.tenantClusterRole.name) | trunc 63 | trimSuffix "-" | quote}}
{{- end }}

{{- define "platform-tenant.deployer.role.name" -}}
{{ (default (printf "%s-%s" .Release.Name "deployer") .Values.components.rbac.tenantDeploymentRole.name) | trunc 63 | trimSuffix "-" | quote}}
{{- end }}  

{{- define "platform-tenant.tls.name" -}}
{{ printf "%s-tls" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-tenant.proxy.name" -}}
{{ printf "%s-proxy" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-tenant.gateway.name" -}}
{{ printf "%s-gateway" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-tenant.certificate.name" -}}
{{ printf "%s-certificate" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-tenant.ingress-route.name" -}}
{{ printf "%s-ingress-route" .Release.Name | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{- define "platform-tenant.require.defaultHost" -}}
{{/* Check application host defaults */}}
{{- range $app := .Values.components.apps }}
{{ $defaultList := list  }}
{{ range $app.hosts }}
{{ $defaultList = append $defaultList ( default .default false )}}
{{- end }}
{{- if and (gt ( len $app.hosts ) 1) ( not ( has true $defaultList )) }}
  {{ fail (printf "When passing multiple, one default host has to be set for app host: '%s'" $app.name )}}
{{- end }}
{{- if ( gt ( len ( without $defaultList nil ) ) 1)  }}
  {{ fail ( printf "Only one default host has to be set for app host: '%s'" $app.name )}}
{{- end }}
{{- end }}
{{- end }}

{{/*
  Template helper for pulling the hosts keys from
  the nests apps

  Returns a map[hosts:[host1,host2,...]]

  Use like {{ $apphosts := (include "platform-tenant.apps.hosts" . | fromYaml ).hosts }}
*/}}
{{- define "platform-tenant.apps.hosts" }}
{{- $wlDomains := list }}
{{- range .Values.components.apps }}
{{- $wlDomains = append $wlDomains .host }}
{{- end }}
{{- dict "hosts" $wlDomains | toYaml }}
{{- end }}