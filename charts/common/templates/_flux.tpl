{{/*
  Many of skyfjell's charts wrap flux CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.flux" }}
{{ fail ( printf "Chart requires %s to be present. See https://fluxcd.io/flux/installation for more info." . ) }}
{{end}}

{{/*
  Checks generally if API version for flux is installed. Currently only checking requires CRDs.
*/}}
{{ define "requires.api.flux.helmRelease" }}
  {{ include "requires.api.flux.custom" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $ ) }}
{{end}}

{{ define "requires.api.flux.kustomize" }}
  {{ include "requires.api.flux.custom" ( list "kustomize.toolkit.fluxcd.io" "Kustomization" $ ) }}
{{end}}

{{ define "requires.api.flux.source" }}
  {{ include "requires.api.flux.custom" ( list "source.toolkit.fluxcd.io" "HelmRepository" $ ) }}
  {{ include "requires.api.flux.custom" ( list "source.toolkit.fluxcd.io" "GitRepository" $ ) }}
{{end}}

{{ define "requires.api.flux.all" }}
  {{ include "requires.api.flux.helmRelease" . }}
  {{ include "requires.api.flux.kustomize" . }}
  {{ include "requires.api.flux.source" . }}
{{ end }}


{{/*
  Checks specifically for a flux api version and resource.

  Use like `{{ include "requires.api.flux.custom" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $) }}`
*/}}
{{- define "requires.api.flux.custom" }}
   {{- include "requires.api" ( prepend . "errorMessage.flux" ) -}}
{{- end -}}
 

