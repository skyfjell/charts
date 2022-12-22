{{- define "platform-system.components.vault-operator.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $parent := $.Values.components.vault -}}
{{- $component := $parent.components.operator -}}

{{- $anno := merge $global.annotations $component.annotations $parent.annotations -}}
{{- $nodeSel := default $global.nodeSelector $component.nodeSelector $parent.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations $parent.nodeSelector -}}

fullnameOverride: {{ list $parent.name $component.name | include "skyfjell.common.format.name" }}

{{- with $anno }}
podAnnotations:
  {{ . | indent 2}}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{ . | indent 2}}
{{- end }}
{{- with $tol }}
tolerations:
  {{ . | indent 2}}
{{- end }}
{{- with $component.serviceAccountAnnotations }}
serviceAccount:
  annotations: {{- toYaml . | nindent 4 }}
{{- end -}}
{{- end }}
