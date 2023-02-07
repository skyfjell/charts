{{- define "platform-auth.app.proxy.template.values" -}}
{{- $component := .Values.components.proxy -}}
{{- $nodeSel := merge $.Values.global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $.Values.global.tolerations $component.tolerations -}}

fullnameOverride: {{ $component.name }}
instanceLabelOverride: {{ $component.name }}
ingressClass:
  enabled: false
providers:
  kubernetesIngress:
    enabled: false
  kubernetesCRD:
    allowCrossNamespace: true
    namespaces:
      ["*"]
service:
  type: ClusterIP
rbac:
  namespaced: false
ingressRoute:
  dashboard:
    enabled: false
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

