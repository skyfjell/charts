{{- define "platformSystem.kyvernoPolicies.defaultValues" -}}
podSecurityStandard: {{ $.Values.components.kyvernoPolicies.podSecurityStandard | quote }}
{{- end -}}

