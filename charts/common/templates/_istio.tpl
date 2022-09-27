{{/*
  Many of skyfjell's charts wrap istio CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.istio" }}
{{ fail ( printf "Chart require %s to be present. See https://istio.io/latest/docs/setup/install for more info." . ) }}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}
{{ define "require.api.istio.gateway" }}
  {{ include "require.api.istio.base" ( list "networking.istio.io" "Gateway" $ ) }}
{{ end }}

{{ define "require.api.istio.sidecar" }}
  {{ include "require.api.istio.base" ( list "networking.istio.io" "Sidecar" $ ) }}
{{ end }}

{{ define "require.api.istio.vs" }}
  {{ include "require.api.istio.base" ( list "networking.istio.io" "VirtualService" $ ) }}
{{ end }}

{{ define "require.api.istio.neworking" }}
  {{ include "require.api.istio.vs" . }}
  {{ include "require.api.istio.sidecar" . }}
  {{ include "require.api.istio.gateway" . }}
{{ end }}

{{ define "require.api.istio.all" }}
  {{ include "require.api.istio.neworking" . }}
{{ end }}


{{/*
  Checks specifically for an istio api version and resource.

  Use like `{{ include "require.api.istio.base" ( list "networking.istio.io" "VirtualService" $) }}`
*/}}
{{- define "require.api.istio.base" }}
   {{- include "require.api" ( prepend . "errorMessage.istio" ) -}}
{{- end -}}
 
 

