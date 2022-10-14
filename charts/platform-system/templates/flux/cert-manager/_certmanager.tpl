{{- define "platformSystem.certManager.defaultValues" -}}
installCRDs: true
{{- with ( include "platformSystem.helper.annotations" (list "certManager" $) ) }}
annotations:
  {{ toYaml . | indent 2}}
{{- end }}
{{- with ( include "platformSystem.helper.tolerations" (list "certManager" $) ) }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platformSystem.helper.nodeSelector" (list "certManager" $) ) }}
nodeSelector:
  {{ toYaml . | indent 2}}
{{- end }}
{{- with .Values.components.certManager.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end }}
webhook:
  securePort: {{ .Values.components.certManager.webhookSecurePort }}
  {{- with ( include "platformSystem.helper.tolerations" (list "certManager" $) ) }}
  tolerations:
    {{ . | indent 4}}
  {{- end }}
  {{- with ( include "platformSystem.helper.nodeSelector" (list "certManager" $) ) }}
  nodeSelector:
    {{ toYaml . | indent 4}}
  {{- end }}
{{ $tol := ( include "platformSystem.helper.tolerations" (list "certManager" $) ) }}
{{ $nsel := ( include "platformSystem.helper.nodeSelector" (list "certManager" $) ) }}
{{ with (or $tol $nsel)}}
cainjector:
  {{- with $tol }}
  tolerations:
    {{ . | indent 4}}
  {{- end }}
  {{- with $nsel }}
  nodeSelector:
    {{ toYaml . | indent 4}}
  {{- end }}
startupapicheck:
  {{- with $tol }}
  tolerations:
    {{ . | indent 4}}
  {{- end }}
  {{- with $nsel }}
  nodeSelector:
    {{ toYaml . | indent 4}}
  {{- end }}
{{- end -}}
{{- end -}}

