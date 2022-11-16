{{- define "platform-system.components.minio-operator.defaultValues" -}}
{{- $anno := ( include "platform-system.helper.annotations" (list "minioOperator" $) ) }}
{{- $sel := ( include "platform-system.helper.nodeSelector" (list "minioOperator" $) ) }}
{{- $tol := ( include "platform-system.helper.tolerations" (list "minioOperator" $) ) }}
{{- if or ( or $tol $sel ) $anno }}
operator:
  {{- with $anno }}
  annotations:
    {{ . | indent 6}}
  {{- end }}
  {{- with $sel }}
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
  {{- with $sel }}
  nodeSelector:
    {{ . | indent 6}}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 6}}
  {{- end }}
{{- end -}}
{{- end -}}