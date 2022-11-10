{{/* 
  Template for building a certificate
*/}}
{{- define "platform-tenant.app.certificate.template" }}
{{ $global := last .}}
{{ $val := first .}}
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ printf "%s-cert" $val.name }}
  namespace: {{ $global.Values.components.istio.namespace }}
spec:
  secretName: {{ include "platform-system.helper.tlsName" $val.name }}
  dnsNames: 
    - {{ $val.url | quote }}
  {{ if not $global.Values.components.certManager.issuerRef }}
  {{ fail ".Values.components.certManager.issuerRef needs to be defined." }}
  {{- end -}}
  issuerRef: {{ $global.Values.components.certManager.issuerRef | toYaml | nindent 4}}
{{- end -}}