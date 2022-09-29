{{/*
  Many of skyfjell's charts wrap cert-manager's CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.cert-manager" }}
{{ fail ( printf "Chart require %s to be present. See https://cert-manager.io/docs/installation for more info." . ) }}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}

{{ define "require.api.cert-manager.certificate" }}
  {{ include "require.api.cert-manager.base" ( list "cert-manager.io" "Certificate" $ ) }}
{{ end }}



{{ define "require.api.cert-manager.all" }}
  {{ include "require.api.cert-manager.certificate" . }}
{{ end }}


{{/*
  Checks specifically for a cert-manager api version and resource.

  Use like `{{ include "require.api.cert-manager.base" ( list "cert-manager.io" "Certificate" $) }}`
*/}}
{{- define "require.api.cert-manager.base" }}
   {{- include "require.api" ( prepend . "errorMessage.cert-manager" ) -}}
{{- end -}}
 
 

