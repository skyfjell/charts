{{/*
  Many of skyfjell's charts wrap traefik CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "skyfjell.common.require.api.traefik.message" }}
  {{- "Traefik is installed as a part of the Platform Auth chart: https://github.com/skyfjell/charts/tree/main/charts/platform-auth" -}}
  {{- "\n" -}}
  {{- "Or to install Traefik: https://doc.traefik.io/traefik/getting-started/install-traefik/#use-the-helm-chart" -}}
{{ end }}

{{/*
  Checks generally if API version for traefik is installed. Currently only checking require CRDs.
*/}}
{{ define "skyfjell.common.require.api.traefik.ingress-route" }}
  {{ include "skyfjell.common.require.api.traefik.base" ( list "traefik.containo.us" "IngressRoute" $ ) }}
{{ end }}

{{ define "skyfjell.common.require.api.traefik.all" }}
  {{ include "skyfjell.common.require.api.traefik.ingress-route" . }}
{{ end }}

{{/*
  Checks specifically for a traefik api version and resource.

  Use like `{{ include "skyfjell.common.require.api.traefik.base" ( list "traefik.containo.us" "IngressRoute" $ ) }}`
*/}}
{{- define "skyfjell.common.require.api.traefik.base" }}
  {{- include "skyfjell.common.require.api.traefik.message" . | prepend . | include "skyfjell.common.require.api" -}}
{{- end -}}
