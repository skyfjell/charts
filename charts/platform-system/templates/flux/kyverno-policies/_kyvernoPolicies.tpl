{{- define "platform-system.components.kyverno-policies.defaultValues" -}}
podSecurityStandard: {{ $.Values.components.kyvernoPolicies.podSecurityStandard | quote }}
{{- end -}}

