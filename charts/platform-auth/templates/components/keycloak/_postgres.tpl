{{- define "platform-auth.components.keycloak.components.database.values" -}}
{{- $component := .Values.components.keycloak.components.database -}}
{{- $parent := .Values.components.keycloak -}}
{{- $server := $parent.components.server -}}
{{- $name := list $parent.name $component.name | include "skyfjell.common.format.name" -}}
{{- $nodeSel := merge $.Values.global.nodeSelector $parent.nodeSelector $component.nodeSelector -}}
{{- $tol := default $.Values.global.tolerations ( default $parent.tolerations $component.tolerations ) -}}

fullnameOverride: {{ $name }}
fullname: {{ $name }}
global:
  postgresql:
    auth:
      database: {{ $component.auth.database }}
      existingSecret: {{ $component.auth.existingSecret }}
      username: {{ $component.auth.username }}
      secretKeys:
      {{- toYaml $component.auth.secretKeys | nindent 8 }}
{{- $chartName := $component.chart.name }}
{{- if or (eq $chartName "postgresql") (eq $chartName "postgresql-ha") }}
{{ if eq $chartName "postgresql" }}
primary:
{{ else if eq $chartName "postgresql-ha" }}
postgres:
{{- end }}
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}
