{{- define "platform-auth.app.postgres.template" -}}
fullnameOverride: {{ include "platform-auth.helper.postgresName" $ }}
fullname: {{ include "platform-auth.helper.postgresName" $ }}
{{- $chartName := .Values.components.keycloak.storage.chart.name }}
{{- if or (eq $chartName "postgresql") (eq $chartName "postgresql-ha") }}
{{ if eq $chartName "postgresql" }}
primary:
{{ else if eq $chartName "postgresql-ha" }}
postgres:
{{- end }}
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{ toYaml . | indent 4 }}
  {{- end -}}
  {{- with .Values.tolerations }}
  tolerations:
  {{ range .Values.tolerations }}
    - {{ .  | quote}}
  {{- end }}
  {{- end }}
{{- end -}}
{{- end -}}