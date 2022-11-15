{{- define "skyfjell.common.format.name" -}}
  {{ join "-" . | lower | trunc 63 | trimSuffix "-" }}
{{- end }}
