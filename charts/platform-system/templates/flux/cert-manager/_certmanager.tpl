{{- define "platform-system.components.cert-manager.defaultValues" -}}
installCRDs: true
{{- with ( include "platform-system.helper.annotations" (list "certManager" $) ) }}
annotations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platform-system.helper.tolerations" (list "certManager" $) ) }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with ( include "platform-system.helper.nodeSelector" (list "certManager" $) ) }}
nodeSelector:
  {{ . | indent 2}}
{{- end }}
{{- with .Values.components.certManager.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end }}
webhook:
  hostNetwork: true
  securePort: {{ .Values.components.certManager.webhookSecurePort }}
  {{- with ( include "platform-system.helper.tolerations" (list "certManager" $) ) }}
  tolerations:
    {{ . | indent 4}}
  {{- end }}
  {{- with ( include "platform-system.helper.nodeSelector" (list "certManager" $) ) }}
  nodeSelector:
    {{ . | indent 4}}
  {{- end }}
{{ $tol := ( include "platform-system.helper.tolerations" (list "certManager" $) ) }}
{{ $nsel := ( include "platform-system.helper.nodeSelector" (list "certManager" $) ) }}
{{ with (or $tol $nsel)}}
cainjector:
  {{- with $tol }}
  tolerations:
    {{ . | indent 4}}
  {{- end }}
  {{- with $nsel }}
  nodeSelector:
    {{ . | indent 4}}
  {{- end }}
startupapicheck:
  {{- with $tol }}
  tolerations:
    {{ . | indent 4}}
  {{- end }}
  {{- with $nsel }}
  nodeSelector:
    {{ . | indent 4}}
  {{- end }}
{{- end -}}
{{- end -}}

