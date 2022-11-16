{{- define "platform-system.components.vault-operator.defaultValues" -}}
{{- $anno := ( include "platform-system.helper.annotations" (list "vaultOperator" $) ) }}
{{- $sel := ( include "platform-system.helper.nodeSelector" (list "vaultOperator" $) ) }}
{{- $tol := ( include "platform-system.helper.tolerations" (list "vaultOperator" $) ) }}
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
  annotations: {{- toYaml . | nindent 8 }}
{{- end }}
{{- end -}}