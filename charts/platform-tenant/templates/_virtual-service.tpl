
{{- define "platform-tenant.app.virtual-service.routing" }}
{{- if .mode }}
{{ .mode }}:
{{- else }}
http:
{{- end }}
  - match:
    - uri:
        prefix: /
    route:
      - destination:
          port:
            number: {{ .service.port }}
          host: {{ .service.host }}
{{- end }}

{{/* 
  Template for building a virtual service
*/}}
{{- define "platform-tenant.app.virtual-service.template" }}
{{- $global := last . }}
{{- $val := first . }}
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ printf "%s-virtual-service" $val.name | quote }}
  namespace: {{ $global.Values.targetNamespace.name | quote }}
  labels: {{- include "skyfjell.common.chartLabels" $global | nindent 4 }}
spec:
  hosts:
    - {{ $val.host }}
  gateways:
    - {{ printf "%s/%s" $global.Values.components.istio.namespace (printf "%s-gateway" $val.name) }}
  {{- $defaultValues := ( include "platform-tenant.app.virtual-service.routing" $val | fromYaml ) }}
{{ ( mergeOverwrite $defaultValues (default dict $val.routingOverride )) | toYaml | indent 2 }}
{{- end -}}