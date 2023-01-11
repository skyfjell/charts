{{/*
  Many of skyfjell's charts wrap istio CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "skyfjell.common.require.api.istio.message" }}
  {{- "Istio is installed as a part of the Platform System chart: https://github.com/skyfjell/charts/tree/main/charts/platform-system" -}}
  {{- "\n" -}}
  {{- "Or to install Istio: https://istio.io/latest/docs/setup/install" -}}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}

{{ define "skyfjell.common.require.api.istio.gateway" }}
  {{ include "skyfjell.common.require.api.istio.base" ( list "networking.istio.io" "Gateway" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.sidecar" }}
  {{ include "skyfjell.common.require.api.istio.base" ( list "networking.istio.io" "Sidecar" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.vs" }}
  {{ include "skyfjell.common.require.api.istio.base" ( list "networking.istio.io" "VirtualService" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.all" }}
  {{ include "skyfjell.common.require.api.istio.networking" . }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.networking" }}
  {{ include "skyfjell.common.require.api.istio.vs" . }}
  {{ include "skyfjell.common.require.api.istio.sidecar" . }}
  {{ include "skyfjell.common.require.api.istio.gateway" . }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.peer-authentication" }}
  {{ include "skyfjell.common.require.api.istio.base" ( list "security.istio.io" "PeerAuthentication" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.authorization-policy" }}
  {{ include "skyfjell.common.require.api.istio.base" ( list "security.istio.io" "AuthorizationPolicy" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.request-authentication" }}
  {{ include "skyfjell.common.require.api.istio.base" ( list "security.istio.io" "RequestAuthentication" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.istio.security" }}
  {{ include "skyfjell.common.require.api.istio.peer-authentication" . }}
  {{ include "skyfjell.common.require.api.istio.authorization-policy" . }}
  {{ include "skyfjell.common.require.api.istio.request-authentication" . }}
{{ end }}

{{/*
  Checks specifically for an istio api version and resource.

  Use like `{{ include "skyfjell.common.require.api.istio.base" ( list "networking.istio.io" "VirtualService" $) }}`
*/}}
{{- define "skyfjell.common.require.api.istio.base" }}
  {{- include "skyfjell.common.require.api.istio.message" . | prepend . | include "skyfjell.common.require.api" -}}
{{- end -}}

