{{- define "platform-system.components.cert-manager.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.certManager -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}

fullnameOverride: {{ $component.name }}

installCRDs: true
{{- with $anno }}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $aff }}
affinity:
  {{- toYaml . | nindent 2 }}
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
    {{- toYaml . | nindent 4}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4}}
  {{- end }}
  {{- with $aff }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{ if or $tol $nodeSel }}
cainjector:
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4}}
  {{- end }}
  {{- with $aff }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
startupapicheck:
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4}}
  {{- end }}
  {{- with $aff }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}

