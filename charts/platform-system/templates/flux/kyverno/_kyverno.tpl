{{- define "platform-system.components.kyverno.defaultValues" -}}
installCRDs: true
{{- with ( include "platform-system.helper.annotations" (list "kyverno" $) ) }}
annotations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platform-system.helper.tolerations" (list "kyverno" $) ) }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platform-system.helper.nodeSelector" (list "kyverno" $) ) }}
nodeSelector:
  {{ . | indent 2}}
{{- end }}
{{- with .Values.components.kyverno.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}
