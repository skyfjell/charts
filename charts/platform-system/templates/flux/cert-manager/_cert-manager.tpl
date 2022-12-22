{{- define "platform-system.components.cert-manager.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $component := $.Values.components.certManager -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}

fullnameOverride: {{ $component.name }}

installCRDs: true
{{- with $anno }}
annotations:
  {{- . | nindent 2}}
{{- end }}
{{- with $tol }}
tolerations:
  {{- . | nindent 2}}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- . | nindent 2}}
{{- end }}
{{- with $component.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end }}
webhook:
  hostNetwork: true
  securePort: {{ $component.webhookSecurePort }}
  {{- with $tol }}
  tolerations:
    {{- . | nindent 4}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- . | nindent 4}}
  {{- end }}
{{ if or $tol $nodeSel }}
cainjector:
  {{- with $tol }}
  tolerations:
    {{- . | nindent 4}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{ . | indent 4}}
  {{- end }}
startupapicheck:
  {{- with $tol }}
  tolerations:
    {{- . | nindent 4}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- . | nindent 4}}
  {{- end }}
{{- end -}}
{{- end -}}

