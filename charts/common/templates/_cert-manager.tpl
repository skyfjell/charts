{{/*
  Many of skyfjell's charts wrap cert-manager's CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "skyfjell.common.require.api.cert-manager.message" }}
  {{- "cert-manager is installed as a part of the Platform System chart: https://github.com/skyfjell/charts/tree/main/charts/platform-system" -}}
  {{- "\n" -}}
  {{- "Or to install cert-manager: https://cert-manager.io/docs/installation" -}}
{{ end }}

{{/*
  Checks generally if API version for flux is installed. Currently only checking require CRDs.
*/}}

{{ define "skyfjell.common.require.api.cert-manager.certificate" }}
  {{ list "cert-manager.io" "Certificate" $ | include "skyfjell.common.require.api.cert-manager.base" }}
{{ end }}



{{ define "skyfjell.common.require.api.cert-manager.all" }}
  {{ include "skyfjell.common.require.api.cert-manager.certificate" . }}
{{ end }}


{{/*
  Checks specifically for a cert-manager api version and resource.

  Use like `{{ list "cert-manager.io" "Certificate" $ | include "skyfjell.common.require.api.cert-manager.base" }}`
*/}}
{{- define "skyfjell.common.require.api.cert-manager.base" }}
  {{- include "skyfjell.common.require.api.cert-manager.message" . | prepend . | include "skyfjell.common.require.api" -}}
{{- end -}}
