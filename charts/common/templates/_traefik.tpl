{{/*
  Many of skyfjell's charts wrap traefik CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "errorMessage.traefik" }}
{{ fail ( printf "Chart require %s to be present. See https://doc.traefik.io/traefik/getting-started/install-traefik/#use-the-helm-chart for more info." . ) }}
{{end}}

{{/*
  Checks generally if API version for traefik is installed. Currently only checking require CRDs.
*/}}
{{ define "require.api.traefik.ingressRoute" }}
  {{ include "require.api.traefik.base" ( list "traefik.containo.us" "IngressRoute" $ ) }}
{{end}}


{{ define "require.api.traefik.all" }}
  {{ include "require.api.traefik.ingressRoute" . }}
{{ end }}


{{/*
  Checks specifically for a traefik api version and resource.

  Use like `{{ include "require.api.traefik.base" ( list "traefik.containo.us" "IngressRoute" $ ) }}`
*/}}
{{- define "require.api.traefik.base" }}
   {{- include "require.api" ( prepend . "errorMessage.traefik" ) -}}
{{- end -}}
 

