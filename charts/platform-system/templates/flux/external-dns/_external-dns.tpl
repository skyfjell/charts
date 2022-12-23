{{- define "platform-system.components.external-dns.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $component := $.Values.components.externalDns -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}

fullnameOverride: {{ $component.name }}

installCRDs: true
{{- with $anno }}
annotations:
  {{ . | nindent 2}}
{{- end }}
{{- with $tol }}
tolerations:
  {{- . | nindent 2}}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- . | nindent 2}}
{{- end }}
{{- with $component.serviceAccountAnnotations }}
serviceAccount:
  annotations:
    {{- toYaml . | nindent 4 }}
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
