{{/*
  Many of skyfjell's charts wrap istio CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.istio" }}
{{ fail ( printf "Chart requires %s to be present. See https://istio.io/latest/docs/setup/install for more info." . ) }}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking required CRDs.
*/}}
{{ define "required.istio.gateway" }}
  {{ include "required.flux.custom" ( list "networking.istio.io" "Gateway" $ ) }}
{{ end }}

{{ define "required.istio.sidecar" }}
  {{ include "required.flux.custom" ( list "networking.istio.io" "Sidecar" $ ) }}
{{ end }}

{{ define "required.istio.vs" }}
  {{ include "required.flux.custom" ( list "networking.istio.io" "VirtualService" $ ) }}
{{ end }}

{{ define "required.istio.neworking" }}
  {{ include "required.istio.vs" . }}
  {{ include "required.istio.sidecar" . }}
  {{ include "required.istio.gateway" . }}
{{ end }}

{{ define "required.istio.all" }}
  {{ include "required.istio.neworking" . }}
{{ end }}


{{/*
  Checks specifically for an istio api version and resource.

  Use like `{{ include "required.istio.custom" ( list "networking.istio.io" "VirtualService" $) }}`
*/}}
{{- define "required.istio.custom" }}
   {{- include "required.common.custom" ( prepend . "errorMessage.istio" ) -}}
{{- end -}}
 
 

