{{- define "platform-factory.components.privatebin.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.privatebin -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}
{{- $labels := merge $global.labels $component.labels -}}

fullnameOverride: {{ $component.name }}
nameOverride: {{ $component.name }}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $aff }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $anno }}
podAnnotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $labels }}
additionalLabels:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

