{{/* 
  Template for building a certificate
*/}}
{{- define "certManager.certificate" }}
{{ $global := last .}}
{{ $val := first .}}
{{ with $val.tls.credentialName }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ printf "%s-cert" . }}
  namespace: {{$global.Values.istio.namespace}}
spec:
  secretName: {{ . | quote}}
  dnsNames: {{ $val.hosts | toYaml | nindent 4 }}
  {{ if not $global.Values.istio.certManager.issuerRef }}
  {{ fail ".Values.istio.certManager.issuerRef needs to be defined." }}
  {{- end -}}
  issuerRef: {{ $global.Values.istio.certManager.issuerRef | toYaml | nindent 4}}
{{- end -}}
{{- end -}}
