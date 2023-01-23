{{- define "platform-auth.app.proxy.template.values" -}}
{{- $component := .Values.components.proxy -}}
fullnameOverride: {{ $component.name }}
nameOverride: {{ $component.name }}
instanceLabelOverride: {{ $component.name }}
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
hostNetwork: true
ingressRoute:
  dashboard:
    enabled: false
nodeSelector:
  {{ default .Values.nodeSelector $component.nodeSelector | toYaml | indent 4 }}
{{- with default .Values.tolerations $component.nodeSelector }}
tolerations:
{{ range . }}
  - {{ .  | quote}}
{{- end }}
{{- end }}
{{- end }}
