{{- define "skyfjell.common.chartLabels" -}}
skyfjell.io/chart: {{ .Chart.Name }}
skyfjell.io/version: {{ .Chart.Version }}
{{- end -}}

{{- define "skyfjell.common.crdCheck" -}}
{{ .Values.crdCheck }}
{{- end -}}

{{- define "skyfjell.common.literalTpl" -}}
{{ "{{" }}{{ . }}{{ "}}" }}
{{- end -}}
