{{- define "platform-system.components.vault-operator.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $component := $.Values.components.vault.components.operator -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}

fullnameOverride: {{ $component.name }}

{{- with $anno }}
podAnnotations:
  {{ . | indent 6}}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{ . | indent 6}}
{{- end }}
{{- with $tol }}
tolerations:
  {{ . | indent 6}}
{{- end }}
{{- with $component.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 8 }}
{{- end }}
{{- end -}}
