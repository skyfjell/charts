{{- define "platformSystem.vaultOperator.defaultValues" -}}
{{- $anno := ( include "platformSystem.helper.annotations" (list "vaultOperator" $) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" (list "vaultOperator" $) ) }}
{{- $tol := ( include "platformSystem.helper.tolerations" (list "vaultOperator" $) ) }}
{{- with $anno }}
podAnnotations:
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
{{- with .Values.components.vaultOperator.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- . | nindent 8 }}
{{- end }}
{{- end -}}