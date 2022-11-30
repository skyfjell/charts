{{- define "platform-system.components.kyverno-policies.defaultValues" -}}
podSecurityStandard: {{ $.Values.components.kyverno.components.policies.podSecurityStandard | quote }}
{{- end -}}

