{{- define "platformSystem.minioTenant.defaultValues" -}}
{{- $anno := ( include "platformSystem.helper.annotations" (list "minioTenant" $) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" (list "minioTenant" $) ) }}
{{- $tol := ( include "platformSystem.helper.tolerations" (list "minioTenant" $) ) }}
tenant:
  pools:
    - storageClassName: {{ default "default" .Values.components.minioTenant.storageClassName }}
      {{- with $anno }}
      annotations: {{- . | nindent 10 }}
      {{- end }}
      {{- with $sel }}
      nodeSelector: {{- . | nindent 10}}
      {{- end }}
      {{- with $tol }}
      tolerations: {{- . | nindent 10}}
      {{- end }}
  prometheus:
    storageClassName: {{ default "default" .Values.components.minioTenant.storageClassName }}
    {{- with $anno }}
    annotations:
      {{ . | indent 8}}
    {{- end }}
    {{- with $sel }}
    nodeSelector:
      {{ . | indent 6}}
    {{- end }}
    {{- with $tol }}
    tolerations: {{- . | nindent 8}}
    {{- end }}
  log:
    {{- with $anno }}
    annotations:
      {{ . | indent 8}}
    {{- end }}
    {{- with $sel }}
    nodeSelector:
      {{ . | indent 8}}
    {{- end }}
    {{- with $tol }}
    tolerations: {{- . | nindent 8 }}
    {{- end }}
    db:
      storageClassName: {{ default "default" .Values.components.minioTenant.storageClassName }}
      {{- with $anno }}
      annotations:
        {{ . | indent 10}}
      {{- end }}
      {{- with $sel }}
      nodeSelector:
        {{ . | indent 10}}
      {{- end }}
      {{- with $tol }}
      tolerations: {{- . | nindent 10}}
      {{- end }}
{{- end -}}