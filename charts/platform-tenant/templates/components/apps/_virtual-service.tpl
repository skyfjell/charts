
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
{{- $ := last . }}
{{- $app := first . }}
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ list $app.name $ | include "platform-tenant.format.name.shared" }}
  namespace: {{ list $ | include "platform-tenant.format.namespace" }}
  labels: {{- include "skyfjell.common.chartLabels" $ | nindent 4 }}
spec:
  hosts:
    - {{ $app.host }}
  gateways:
    - {{ (list $app.name $ | include "platform-tenant.format.name.shared" ) | printf "%s/%s" $.Values.components.istio.namespace }}
  {{- $defaultValues := (include "platform-tenant.app.virtual-service.routing" $app | fromYaml) }}
{{ (mergeOverwrite $defaultValues (default dict $app.routingOverride)) | toYaml | indent 2 }}
{{- end -}}
