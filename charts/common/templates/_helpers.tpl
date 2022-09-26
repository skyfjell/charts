{{ define "chart.requires" }}
{{- fail (printf "Chart requires %s to be present" . ) -}}
{{end}}

