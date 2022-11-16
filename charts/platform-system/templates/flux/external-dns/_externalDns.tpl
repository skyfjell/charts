{{- define "platform-system.components.external-dns.defaultValues" -}}
installCRDs: true
{{- with ( include "platform-system.helper.annotations" (list "externalDns" $) ) }}
annotations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platform-system.helper.tolerations" (list "externalDns" $) ) }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platform-system.helper.nodeSelector" (list "externalDns" $) ) }}
nodeSelector:
  {{ . | indent 2}}
{{- end }}
{{- with .Values.components.externalDns.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end }}
global:
  enabled: false
  name: external-dns
server:
  enabled: true
  replicas: 1
  boostrapExpect: 1
podSecurityContext:
  fsGroup: 65534 # For ExternalDNS to be able to read Kubernetes and AWS token files
sources:
  - service
  - ingress
  - istio-gateway
  - istio-virtualservice
{{- end -}}
