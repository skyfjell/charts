{{- define "platform-system.components.external-dns.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.externalDns -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}

fullnameOverride: {{ $component.name }}

installCRDs: true
{{- with $anno }}
annotations:
  {{ toYaml . | nindent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $aff }}
affinity:
  {{- toYaml . | nindent 2 }}
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
