{{- define "platform-system.components.vault-operator.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $parent := $.Values.components.vault -}}
{{- $component := $parent.components.operator -}}

{{- $anno := merge $global.annotations $component.annotations $parent.annotations -}}
{{- $nodeSel := default $global.nodeSelector $component.nodeSelector $parent.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations $parent.nodeSelector -}}

fullnameOverride: {{ list $parent.name $component.name $ | include "skyfjell.common.format.name" }}

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
