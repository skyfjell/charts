{{/* 
  Template for building a certificate
*/}}
{{- define "platform-tenant.app.certificate" }}
{{ $global := last .}}
{{ $val := first .}}
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ printf "%s-cert" $val.name }}
  namespace: {{ $global.Values.istio.namespace }}
spec:
  secretName: {{ include "platform-system.helper.tlsName" $val.name }}
  dnsNames: 
    - {{ $val.url | quote }}
  {{ if not $global.Values.certManager.issuerRef }}
  {{ fail ".Values.certManager.issuerRef needs to be defined." }}
  {{- end -}}
  issuerRef: {{ $global.Values.certManager.issuerRef | toYaml | nindent 4}}
{{- end -}}