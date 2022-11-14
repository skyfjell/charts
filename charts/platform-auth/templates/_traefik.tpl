{{- define "platform-auth.app.traefik.template" -}}
fullnameOverride: {{ include "platform-auth.traefik.name" $ }}
fullname: {{ include "platform-auth.traefik.name" $ }}
ingressClass:
  enabled: false
providers:
  kubernetesIngress:
    enabled: false
  kubernetesCRD:
    allowCrossNamespace: true
service:
  type: ClusterIP
rbac:
  namespaced: false
ingressRoute:
  dashboard:
    enabled: false
nodeSelector:
  {{ toYaml .Values.nodeSelector | indent 4 }}
{{- if .Values.tolerations }}
tolerations:
{{ range .Values.tolerations }}
  - {{ .  | quote}}
{{- end }}
{{- end }}
{{- end -}}
