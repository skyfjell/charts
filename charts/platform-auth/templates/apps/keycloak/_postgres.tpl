{{- define "platform-auth.components.keycloak.components.database.values" -}}
{{ $component := .Values.components.keycloak.components.database }}
{{ $parentComponent := .Values.components.keycloak }}
{{ $name := list $parentComponent.name $component.name $ | include "platform-auth.format.name" }}
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
  nodeSelector:
    {{ toYaml .Values.nodeSelector | indent 4 }}
  {{- if .Values.tolerations }}
  tolerations:
  {{ range .Values.tolerations }}
    - {{ .  | quote}}
  {{- end }}
  {{- end }}
{{- end -}}
{{- end -}}