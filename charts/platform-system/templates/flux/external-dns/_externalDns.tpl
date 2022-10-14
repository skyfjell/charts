{{- define "platformSystem.externalDns.defaultValues" -}}
installCRDs: true
{{- with ( include "platformSystem.helper.annotations" (list "externalDns" $) ) }}
annotations:
  {{ toYaml . | indent 2}}
{{- end }}
{{- with ( include "platformSystem.helper.tolerations" (list "externalDns" $) ) }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platformSystem.helper.nodeSelector" (list "externalDns" $) ) }}
nodeSelector:
  {{ toYaml . | indent 2}}
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
