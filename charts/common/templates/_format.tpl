{{- define "skyfjell.common.format.name" -}}
  {{- compact . | join "-" | lower | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "skyfjell.common.format.component.namespace" -}}
  {{- $ := last . -}}
  {{- $component := first . -}}
  {{- default $component.name $component.namespace | list $.Values.prefix | include "skyfjell.common.format.name" -}}
{{- end -}}

{{- define "skyfjell.common.format.literal" -}}
{{ "{{ " }}{{ . }}{{ " }}" }}
{{- end -}}

{{- define "skyfjell.common.format.safe" -}}
  {{- regexReplaceAll "[^.a-zA-Z0-9-]+" . "-" | trimAll "-" | lower -}}
{{- end -}}
