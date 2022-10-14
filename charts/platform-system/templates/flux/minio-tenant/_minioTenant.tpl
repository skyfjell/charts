{{- define "platformSystem.minioTenant.defaultValues" -}}
{{- $anno := ( include "platformSystem.helper.annotations" (list "minioTenant" $) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" (list "minioTenant" $) ) }}
{{- $tol := ( include "platformSystem.helper.tolerations" (list "minioTenant" $) ) }}
tenant:
  pools:
    - storageClassName: {{ default "default" .Values.components.minioTenant.storageClassName }}
      {{- with $anno }}
      annotations: {{- toYaml . | nindent 10 }}
      {{- end }}
      {{- with $sel }}
      nodeSelector: {{- toYaml . | nindent 10}}
      {{- end }}
      {{- with $tol }}
      tolerations: {{- . | nindent 10}}
      {{- end }}
  prometheus:
    storageClassName: {{ default "default" .Values.components.minioTenant.storageClassName }}
    {{- with $anno }}
    annotations:
      {{ toYaml . | indent 8}}
    {{- end }}
    {{- with $sel }}
    nodeSelector:
      {{ toYaml . | indent 6}}
    {{- end }}
    {{- with $tol }}
    tolerations: {{- . | nindent 8}}
    {{- end }}
  log:
    {{- with $anno }}
    annotations:
      {{ toYaml . | indent 8}}
    {{- end }}
    {{- with $sel }}
    nodeSelector:
      {{ toYaml . | indent 8}}
    {{- end }}
    {{- with $tol }}
    tolerations: {{- . | nindent 8 }}
    {{- end }}
    db:
      storageClassName: {{ default "default" .Values.components.minioTenant.storageClassName }}
      {{- with $anno }}
      annotations:
        {{ toYaml . | indent 10}}
      {{- end }}
      {{- with $sel }}
      nodeSelector:
        {{ toYaml . | indent 10}}
      {{- end }}
      {{- with $tol }}
      tolerations: {{- . | nindent 10}}
      {{- end }}
{{- end -}}