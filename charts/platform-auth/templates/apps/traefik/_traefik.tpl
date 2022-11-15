{{- define "platform-auth.app.traefik.template.values" -}}
{{ $component := .Values.components.traefik }}
fullnameOverride: {{ list $component.name $ | include "platform-auth.format.name" }}
fullname: {{ list $component.name $ | include "platform-auth.format.name" }}
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
