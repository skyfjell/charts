{{- define "platform-auth.components.keycloak.components.database.values" -}}
{{ $name := list "keycloak" "db" $ | include "platform-auth.format.name" }}
fullnameOverride: {{ $name }}
fullname: {{ $name }}
global:
  postgresql:
    auth:
      database: {{ .Values.components.keycloak.components.database.auth.database }}
      existingSecret: {{ .Values.components.keycloak.components.database.auth.existingSecret }}
      username: {{ .Values.components.keycloak.components.database.auth.username }}
      secretKeys:
      {{- toYaml .Values.components.keycloak.components.database.auth.secretKeys | nindent 8 }}  
{{- $chartName := .Values.components.keycloak.components.database.chart.name }}
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