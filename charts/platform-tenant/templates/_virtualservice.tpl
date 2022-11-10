{{/* 
  Template for building a virtual service
*/}}
{{- define "platform-tenant.app.virtualservice.template" }}
{{- $global := last . }}
{{- $val := first . }}
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ printf "%s-virtual-service" $val.name | quote }}
  namespace: {{ $global.Values.targetNamespace.name | quote }}
spec:
  hosts:
    - {{ $val.url }}
  gateways:
    - {{ printf "%s/%s" $global.Values.istio.namespace (printf "%s-gateway" $val.name) }}
  {{- if eq ($val).mode "tls" }}
  tls:
  {{- else if  eq ($val).mode "tcp" }}
  tcp:
  {{- else }}
  http:
  {{- end }}
    - match:
      - uri:
          prefix: /
      route:
        - destination:
            port:
              number: {{ $val.service.port }}
            host: {{ $val.service.host }}
{{- end -}}