{{- define "skyfjell.common.chartLabels" -}}
skyfjell.io/chart: {{ .Chart.Name }}
skyfjell.io/version: {{ .Chart.Version }}
{{- end -}}

{{/*
  Only to be used in a if/else statement. Will return a "1" string 
  that is interpreted as true or empty string which is interpreted as false. 
*/}}
{{- define "skyfjell.common.crdCheck" -}}
{{ if .Values.crdCheck }}
{{ "1" }}
{{ else}}
{{ "" }}
{{- end -}}
{{- end -}}

{{- define "skyfjell.common.literalTpl" -}}
{{ "{{ " }}{{ . }}{{ " }}" }}
{{- end -}}
