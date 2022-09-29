{{/*
  Many of skyfjell's charts wrap kyerno CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.kyerno" }}
{{ fail ( printf "Chart require %s to be present. See https://kyverno.io/docs/installation for more info." . ) }}
{{end}}

{{/*
  Checks generally if API version for kyerno is installed. Currently only checking require CRDs.
*/}}
{{ define "require.api.kyerno.clusterpolicy" }}
  {{ include "require.api.kyerno.base" ( list "kyverno.io" "ClusterPolicy" $ ) }}
{{end}}

{{ define "require.api.kyerno.policy" }}
  {{ include "require.api.kyerno.base" ( list "kyverno.io" "Policy" $ ) }}
{{end}}


{{ define "require.api.kyerno.all" }}
  {{ include "require.api.kyerno.clusterpolicy" . }}
  {{ include "require.api.kyerno.policy" . }}
{{ end }}


{{/*
  Checks specifically for a kyerno api version and resource.

  Use like `{{ include "require.api.kyerno.base" ( list "kyverno.io" "ClusterPolicy" $) }}`
*/}}
{{- define "require.api.kyerno.base" }}
   {{- include "require.api" ( prepend . "errorMessage.kyerno" ) -}}
{{- end -}}
 

