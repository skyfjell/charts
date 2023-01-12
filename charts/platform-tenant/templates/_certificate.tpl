{{/*
  Template for building a certificate
*/}}
{{- define "certManager.certificate" }}
{{ $ := last .}}
{{ $val := first .}}
{{ with $val.tls.credentialName }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ printf "%s-cert" . }}
  namespace: {{ $.Values.istio.namespace }}
spec:
  secretName: {{ . | quote}}
  dnsNames: {{ $val.hosts | toYaml | nindent 4 }}
  {{ if not $.Values.istio.certManager.issuerRef }}
  {{ fail ".Values.istio.certManager.issuerRef needs to be defined." }}
  {{- end -}}
  issuerRef: {{ $.Values.istio.certManager.issuerRef | toYaml | nindent 4}}
{{- end -}}
{{- end -}}
