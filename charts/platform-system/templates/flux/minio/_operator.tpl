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
    {{ . | indent 6}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{ . | indent 6}}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 6}}
  {{- end }}
console:
  {{- with $anno }}
  annotations:
    {{ . | indent 6}}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{ . | indent 6}}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 6}}
  {{- end }}
{{- end -}}
{{- end -}}
