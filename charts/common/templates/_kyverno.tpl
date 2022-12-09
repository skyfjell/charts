{{/*
  Many of skyfjell's charts wrap kyverno CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.kyverno" }}
{{ fail ( printf "Chart require %s to be present. See https://kyverno.io/docs/installation for more info." . ) }}
{{end}}

{{/*
  Checks generally if API version for kyverno is installed. Currently only checking require CRDs.
*/}}
{{ define "require.api.kyverno.clusterPolicy" }}
  {{ include "require.api.kyverno.base" ( list "kyverno.io" "ClusterPolicy" $ ) }}
{{end}}

{{ define "require.api.kyverno.policy" }}
  {{ include "require.api.kyverno.base" ( list "kyverno.io" "Policy" $ ) }}
{{end}}


{{ define "require.api.kyverno.all" }}
  {{ include "require.api.kyverno.clusterPolicy" . }}
  {{ include "require.api.kyverno.policy" . }}
{{ end }}


{{/*
  Checks specifically for a kyverno api version and resource.

  Use like `{{ include "require.api.kyverno.base" ( list "kyverno.io" "ClusterPolicy" $) }}`
*/}}
{{- define "require.api.kyverno.base" }}
   {{- include "require.api" ( prepend . "errorMessage.kyverno" ) -}}
{{- end -}}
 

