{{- define "platform-system.components.minio-operator.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.minio.components.operator -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}

{{- if or $tol $nodeSel $anno }}
operator:
  {{- with $anno }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $aff }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
console:
  {{- with $anno }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $aff }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}
