{{- define "platform-system.istio.istio-base.values" }}
{{ $istioValues := .Values.apps.istio}}
{{- with $istioValues.helmRelease.base.values }}
  {{- omit . "global" | toYaml }}
{{- end }}
global:
  istioNamespace: {{ $istioValues.namespace }}
  {{- with ($istioValues.helmRelease.base.values).global }}
    {{- omit . "istioNamespace" | toYaml | nindent 2 }}
  {{- end }}
{{- end -}}