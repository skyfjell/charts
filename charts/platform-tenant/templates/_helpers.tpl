{{/*
Expand the name of the chart.
*/}}
{{- define "platform-tenant.name" -}}
  {{- default (.Release.Name | trimPrefix "tenant-") .Values.nameOverride -}}
{{- end }}

{{- define "platform-tenant.format.name.local" -}}
  {{- $ := last . -}}
  {{- $name := last . | include "platform-tenant.name" -}}
  {{- $name := default $name $.Values.fullnameOverride -}}
  {{- $name | prepend . | initial | include "skyfjell.common.format.name" -}}
{{- end -}}

{{- define "platform-tenant.format.name.shared" -}}
  {{- $ := last . -}}
  {{- $prefix := $.Values.prefix -}}
  {{- $name := . | include "platform-tenant.format.name.local" -}}
  {{- $name := list $prefix $name | include "skyfjell.common.format.name" -}}
  {{- default $name $.Values.fullnameOverride -}}
{{- end -}}

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
{{- if .Values.serviceAccount.enabled }}
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
{{- define "platform-tenant.apps.hosts" -}}
{{- $hosts := list -}}
{{- range .Values.components.apps -}}
{{- $hosts = append $hosts .host -}}
{{- end -}}
{{- dict "hosts" $hosts | toYaml -}}
{{- end -}}
