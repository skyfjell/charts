{{/*
  Many of skyfjell's charts wrap flux CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.flux" }}
{{ fail ( printf "Chart requires %s to be present. See https://fluxcd.io/flux/installation/" ) }}
{{end}}

{{/*
  Checks generally if API version for flux is installed. Currently only checking required CRDs.
*/}}
{{ define "required.flux.helmRelease" }}
  {{- if not ( .Capabilities.APIVersions.Has "helm.toolkit.fluxcd.io/v1beta2" ) -}}
    {{- include "errorMessage.flux" "helm.toolkit.fluxcd.io/v2beta1" -}}
  {{ end }}
{{end}}

{{ define "required.flux.kustomize" }}
  {{- if not ( .Capabilities.APIVersions.Has "kustomize.toolkit.fluxcd.io/v1beta2" ) -}}
    {{- include "errorMessage.flux" "kustomize.toolkit.fluxcd.io/v1beta2" -}}
  {{ end }}
{{end}}

{{ define "required.flux.source" }}
  {{- if not ( .Capabilities.APIVersions.Has "source.toolkit.fluxcd.io/v1beta2" ) -}}
    {{- include "errorMessage.flux" "source.toolkit.fluxcd.io/v1beta2" -}}
  {{ end }}
{{end}}

{{ define "required.flux.all" }}
  {{ include "required.flux.helmRelease" .}}
  {{ include "required.flux.kustomize" .}}
  {{ include "required.flux.source" .}}
{{ end }}

{{/*
  Checks specifically for a flux api version and resource.

  Use like `{{ include "required.flux.custom" ( list . "helm.toolkit.fluxcd.io/v1beta2/HelmRelease" ) }}`
*/}}
{{ define "required.flux.custom" }}
  {{ $global := (first .)}}
  {{ $crd := (last .)}}
  {{- if not ( $global.Capabilities.APIVersions.Has $crd ) -}}
    {{- include "errorMessage.flux" $crd -}}
  {{ end }}
{{ end }}