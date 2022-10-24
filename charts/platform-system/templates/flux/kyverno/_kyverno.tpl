{{- define "platformSystem.kyverno.defaultValues" -}}
installCRDs: true
{{- with ( include "platformSystem.helper.annotations" (list "kyverno" $) ) }}
annotations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platformSystem.helper.tolerations" (list "kyverno" $) ) }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platformSystem.helper.nodeSelector" (list "kyverno" $) ) }}
nodeSelector:
  {{ . | indent 2}}
{{- end }}
{{- with .Values.components.kyverno.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}
