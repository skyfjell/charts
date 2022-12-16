{{- define "platform-auth.components.keycloak.components.database.values" -}}
{{- $component := .Values.components.keycloak.components.database -}}
{{- $parent := .Values.components.keycloak -}}
{{- $name := list $parent.name $component.name | include "skyfjell.common.format.name" -}}
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
    {{ default .Values.nodeSelector $parent.nodSelector $component.nodeSelector | toYaml | indent 4 }}
  {{- with default .Values.tolerations $parent.tolerations $component.tolerations }}
  tolerations:
  {{ range . }}
    - {{ .  | quote}}
  {{- end }}
  {{- end }}
{{- end -}}
{{- end -}}
