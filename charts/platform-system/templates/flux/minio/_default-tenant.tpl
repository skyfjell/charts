{{- define "platform-system.components.minio-tenant.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $parent := $.Values.components.minio -}}
{{- $component := $parent.components.tenant -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}

tenant:
  pools:
    - storageClassName: {{ default "default" $component.storageClassName }}
      {{- with $anno }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $nodeSel }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $tol }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $aff }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  prometheus:
    storageClassName: {{ default "default" $component.storageClassName }}
    {{- with $anno }}
    annotations:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $nodeSel }}
    nodeSelector:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $tol }}
    tolerations:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $aff }}
      affinity:
        {{- toYaml . | nindent 6 }}
    {{- end }}
  log:
    {{- with $anno }}
    annotations:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $nodeSel }}
    nodeSelector:
      {{ toYaml . | nindent 6 }}
    {{- end }}
    {{- with $tol }}
    tolerations:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $aff }}
    affinity:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    db:
      storageClassName: {{ default "default" $component.storageClassName }}
      {{- with $anno }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $nodeSel }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $tol }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $aff }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end -}}
