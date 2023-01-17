{{- define "skyfjell.common.chartLabels" -}}
skyfjell.io/chart: {{ include "skyfjell.common.format.safe" .Chart.Name }}
skyfjell.io/version: {{ include "skyfjell.common.format.safe" .Chart.Version }}
{{- end -}}



