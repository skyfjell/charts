{{/*
  Many of skyfjell's charts wrap cert-manager's CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.certManager" }}
{{ fail ( printf "Chart require %s to be present. See https://cert-manager.io/docs/installation for more info." . ) }}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}

{{ define "require.api.certManager.certificate" }}
  {{ include "require.api.certManager.base" ( list "cert-manager.io" "Certificate" $ ) }}
{{ end }}



{{ define "require.api.certManager.all" }}
  {{ include "require.api.certManager.certificate" . }}
{{ end }}


{{/*
  Checks specifically for a cert-manager api version and resource.

  Use like `{{ include "require.api.certManager.base" ( list "cert-manager.io" "Certificate" $) }}`
*/}}
{{- define "require.api.certManager.base" }}
   {{- include "require.api" ( prepend . "errorMessage.certManager" ) -}}
{{- end -}}
