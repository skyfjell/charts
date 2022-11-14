{{- define "platform-auth.app.postgres.template" -}}
fullnameOverride: {{ include "platform-auth.postgresql.name" $ }}
fullname: {{ include "platform-auth.postgresql.name" $ }}
global:
  postgresql:
    auth:
      database: {{ .Values.components.keycloak.storage.auth.database }}
      existingSecret: {{ .Values.components.keycloak.storage.auth.existingSecret }}
      username: {{ .Values.components.keycloak.storage.auth.username }}
      secretKeys:
      {{- toYaml .Values.components.keycloak.storage.auth.secretKeys | nindent 8 }}  
{{- $chartName := .Values.components.keycloak.storage.chart.name }}
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