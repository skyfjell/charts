{{/*
  Many of skyfjell's charts wrap flux CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "skyfjell.common.require.api.flux.message" }}
  {{- "Flux is required. Install Flux: https://fluxcd.io/flux/installation" -}}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}
{{ define "skyfjell.common.require.api.flux.helm-release" }}
  {{ list "helm.toolkit.fluxcd.io" "HelmRelease" . | include "skyfjell.common.require.api.flux.base" }}
{{ end }}

{{ define "skyfjell.common.require.api.flux.kustomize" }}
  {{ list "kustomize.toolkit.fluxcd.io" "Kustomization" $ | include "skyfjell.common.require.api.flux.base" }}
{{ end }}

{{ define "skyfjell.common.require.api.flux.source" }}
  {{ list "source.toolkit.fluxcd.io" "HelmRepository" . | include "skyfjell.common.require.api.flux.base" }}
  {{ list "source.toolkit.fluxcd.io" "GitRepository" . | include "skyfjell.common.require.api.flux.base" }}
{{ end }}

{{ define "skyfjell.common.require.api.flux.all" }}
  {{ include "skyfjell.common.require.api.flux.helm-release" . }}
  {{ include "skyfjell.common.require.api.flux.kustomize" . }}
  {{ include "skyfjell.common.require.api.flux.source" . }}
{{ end }}


{{/*
  Checks specifically for a flux api version and resource.

  Use like `{{ include "skyfjell.common.require.api.flux.base" ( list "helm.toolkit.fluxcd.io" "HelmRelease" $) }}`
*/}}
{{- define "skyfjell.common.require.api.flux.base" }}
  {{- include "skyfjell.common.require.api.flux.message" . | prepend . | include "skyfjell.common.require.api" -}}
{{- end -}}


