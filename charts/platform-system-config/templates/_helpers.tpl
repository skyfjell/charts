{{- define "platform-system-config.velero.scheduleLookup" -}}
{{- if eq . "hourly" -}}
{{ "0 * * * *" }}
{{- else if eq . "daily" -}}
{{ "0 0 * * *" }}
{{- else if eq . "weekly" -}}
{{ "0 0 * * 0" }}
{{- else if eq . "monthly" -}}
{{ "0 0 1 * *" }}
{{- else if eq . "yearly" -}}
{{ "0 0 1 1 *" }}
{{- else -}}
{{- fail (printf "The schedule key %s is not supported" .) -}}
{{- end -}}
{{- end -}}