{{/* 
  Template for building each app's gateway
*/}}
{{- define "platform-tenant.app.gateway" }}
{{- $global := last . }}
{{- $val := first . }}
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: {{ printf "%s-gateway" $val.name  }}
  namespace: {{ $global.Values.istio.namespace }}
spec:
  {{- with $global.Values.istio.selector }}
  selector:
    {{ toYaml . | indent 4 }}
  {{- end }}
  servers:
     - port:
         number: 443
         name: https
         protocol: HTTPS
       host:
        - {{ $val.url | quote }}
       tls:
        mode: SIMPLE
        credentialName: {{ include "platform-system.helper.tlsName" $val.name }}
{{- end -}}