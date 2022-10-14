{{- define "platformSystem.minioOperator.defaultValues" -}}
{{- $anno := ( include "platformSystem.helper.annotations" (list "minioOperator" $) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" (list "minioOperator" $) ) }}
{{- $tol := ( include "platformSystem.helper.tolerations" (list "minioOperator" $) ) }}
{{- if or ( or $tol $sel ) $anno }}
operator:
  {{- with $anno }}
  annotations:
    {{ toYaml . | indent 6}}
  {{- end }}
  {{- with $sel }}
  nodeSelector:
    {{ toYaml . | indent 6}}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 6}}
  {{- end }}
console:
  {{- with $anno }}
  annotations:
    {{ toYaml . | indent 6}}
  {{- end }}
  {{- with $sel }}
  nodeSelector:
    {{ toYaml . | indent 6}}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 6}}
  {{- end }}
{{- end -}}
{{- end -}}