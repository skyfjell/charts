{{- define "platform-system.components.kyverno.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $component := $.Values.components.kyverno -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}

fullnameOverride: {{ $component.name }}

installCRDs: true

{{- with $anno }}
annotations:
  {{- . | nindent 2}}
{{- end }}

{{- with $tol }}
tolerations:
  {{- . | nindent 2}}
{{- end }}

{{- with $nodeSel }}
nodeSelector:
  {{- . | nindent 2}}
{{- end }}

{{- with $component.serviceAccountAnnotations }}
serviceAccount:
  annotations:
    {{- toYaml . | nindent 4 }}
{{- end }}
{{- end }}
