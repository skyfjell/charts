{{- define "platform-system.components.minio-operator.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $component := $.Values.components.minioOperator -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}

{{- if or $tol $nodeSel $anno }}
operator:
  {{- with $anno }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- . | nindent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{- . | nindent 4 }}
  {{- end }}
console:
  {{- with $anno }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- . | nindent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{- . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}
