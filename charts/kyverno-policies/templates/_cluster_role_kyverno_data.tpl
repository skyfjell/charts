{{/*
Not a valid resource by itself, used in kyverno policies
*/}}
{{- include "kyverno-policies.component.istio-proxy-quit.role" -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
name: "{{ request.object.metadata.name \}\}"
{{- end -}}