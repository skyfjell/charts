{{/*
  Many of skyfjell's charts wrap flux CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.flux" }}
{{ fail ( printf "Chart require %s to be present. See https://fluxcd.io/flux/installation for more info." . ) }}
{{end}}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}
{{ define "require.api.flux.helmRelease" }}
  {{ include "require.api.flux.base" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $ ) }}
{{end}}

{{ define "require.api.flux.kustomize" }}
  {{ include "require.api.flux.base" ( list "kustomize.toolkit.fluxcd.io" "Kustomization" $ ) }}
{{end}}

{{ define "require.api.flux.source" }}
  {{ include "require.api.flux.base" ( list "source.toolkit.fluxcd.io" "HelmRepository" $ ) }}
  {{ include "require.api.flux.base" ( list "source.toolkit.fluxcd.io" "GitRepository" $ ) }}
{{end}}

{{ define "require.api.flux.all" }}
  {{ include "require.api.flux.helmRelease" . }}
  {{ include "require.api.flux.kustomize" . }}
  {{ include "require.api.flux.source" . }}
{{ end }}


{{/*
  Checks specifically for a flux api version and resource.

  Use like `{{ include "require.api.flux.base" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $) }}`
*/}}
{{- define "require.api.flux.base" }}
   {{- include "require.api" ( prepend . "errorMessage.flux" ) -}}
{{- end -}}
 

