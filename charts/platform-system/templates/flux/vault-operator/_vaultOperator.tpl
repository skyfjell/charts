{{- define "platformSystem.vaultOperator.defaultValues" -}}
{{- $anno := ( include "platformSystem.helper.annotations" (list "vaultOperator" $) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" (list "vaultOperator" $) ) }}
{{- $tol := ( include "platformSystem.helper.tolerations" (list "vaultOperator" $) ) }}
{{- with $anno }}
podAnnotations:
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
{{- with .Values.components.vaultOperator.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 8 }}
{{- end }}
{{- end -}}