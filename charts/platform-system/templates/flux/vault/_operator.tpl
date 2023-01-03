{{- define "platform-system.components.vault-operator.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $parent := $.Values.components.vault -}}
{{- $component := $parent.components.operator -}}

{{- $anno := merge $global.annotations $component.annotations $parent.annotations -}}
{{- $nodeSel := default $global.nodeSelector $component.nodeSelector $parent.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations $parent.nodeSelector -}}
{{- $aff := default $global.affinity $component.affinity $parent.affinity -}}

fullnameOverride: {{ list $parent.name $component.name | include "skyfjell.common.format.name" }}
{{- with $aff }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $anno }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $component.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end -}}
{{- end }}
