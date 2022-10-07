{{- define "istio-install.istio-base.values" }}
{{- with $.Values.helmRelease.base.values }}
  {{- omit . "global" | toYaml }}
{{- end }}
global:
  istioNamespace: {{ $.Values.namespace }}
  {{- with ($.Values.helmRelease.base.values).global }}
    {{- omit . "istioNamespace" | toYaml | nindent 2 }}
  {{- end }}
{{- end -}}