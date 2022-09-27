{{/*
  Many of skyfjell's charts wrap flux CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.flux" }}
{{ fail ( printf "Chart requires %s to be present. See https://fluxcd.io/flux/installation for more info." . ) }}
{{end}}

{{/*
  Checks generally if API version for flux is installed. Currently only checking required CRDs.
*/}}
{{ define "required.flux.helmRelease" }}
  {{ include "required.flux.custom" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $ ) }}
{{end}}

{{ define "required.flux.kustomize" }}
  {{ include "required.flux.custom" ( list "kustomize.toolkit.fluxcd.io" "Kustomization" $ ) }}
{{end}}

{{ define "required.flux.source" }}
  {{ include "required.flux.custom" ( list "source.toolkit.fluxcd.io" "HelmRepository" $ ) }}
  {{ include "required.flux.custom" ( list "source.toolkit.fluxcd.io" "GitRepository" $ ) }}
{{end}}

{{ define "required.flux.all" }}
  {{ include "required.flux.helmRelease" . }}
  {{ include "required.flux.kustomize" . }}
  {{ include "required.flux.source" . }}
{{ end }}


{{/*
  Checks specifically for a flux api version and resource.

  Use like `{{ include "required.flux.custom" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $) }}`
*/}}
{{- define "required.flux.custom" }}
   {{- include "required.common.custom" ( prepend . "errorMessage.flux" ) -}}
{{- end -}}
 

