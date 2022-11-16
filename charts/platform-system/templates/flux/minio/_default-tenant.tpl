{{- define "platform-system.components.minio-tenant.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $parent := $.Values.components.minioOperator -}}
{{- $component := $parent.components.tenant -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}

tenant:
  pools:
    - storageClassName: {{ default "default" $component.storageClassName }}
      {{- with $anno }}
      annotations: {{- . | nindent 10 }}
      {{- end }}
      {{- with $nodeSel }}
      nodeSelector: {{- . | nindent 10}}
      {{- end }}
      {{- with $tol }}
      tolerations: {{- . | nindent 10}}
      {{- end }}
  prometheus:
    storageClassName: {{ default "default" $component.storageClassName }}
    {{- with $anno }}
    annotations:
      {{ . | indent 8}}
    {{- end }}
    {{- with $nodeSel }}
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
    {{- with $nodeSel }}
    nodeSelector:
      {{ . | indent 8}}
    {{- end }}
    {{- with $tol }}
    tolerations: {{- . | nindent 8 }}
    {{- end }}
    db:
      storageClassName: {{ default "default" $component.storageClassName }}
      {{- with $anno }}
      annotations:
        {{ . | indent 10}}
      {{- end }}
      {{- with $nodeSel }}
      nodeSelector:
        {{ . | indent 10}}
      {{- end }}
      {{- with $tol }}
      tolerations: {{- . | nindent 10}}
      {{- end }}
{{- end -}}
