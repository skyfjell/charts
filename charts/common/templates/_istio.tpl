{{/*
  Many of skyfjell's charts wrap istio CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.istio" }}
{{ fail ( printf "Chart requires %s to be present. See https://istio.io/latest/docs/setup/install for more info." . ) }}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking requires CRDs.
*/}}
{{ define "requires.api.istio.gateway" }}
  {{ include "requires.api.istio.custom" ( list "networking.istio.io" "Gateway" $ ) }}
{{ end }}

{{ define "requires.api.istio.sidecar" }}
  {{ include "requires.api.istio.custom" ( list "networking.istio.io" "Sidecar" $ ) }}
{{ end }}

{{ define "requires.api.istio.vs" }}
  {{ include "requires.api.istio.custom" ( list "networking.istio.io" "VirtualService" $ ) }}
{{ end }}

{{ define "requires.api.istio.neworking" }}
  {{ include "requires.api.istio.vs" . }}
  {{ include "requires.api.istio.sidecar" . }}
  {{ include "requires.api.istio.gateway" . }}
{{ end }}

{{ define "requires.api.istio.all" }}
  {{ include "requires.api.istio.neworking" . }}
{{ end }}


{{/*
  Checks specifically for an istio api version and resource.

  Use like `{{ include "requires.api.istio.custom" ( list "networking.istio.io" "VirtualService" $) }}`
*/}}
{{- define "requires.api.istio.custom" }}
   {{- include "requires.api" ( prepend . "errorMessage.istio" ) -}}
{{- end -}}
 
 

