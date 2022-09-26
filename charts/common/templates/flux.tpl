{{/*
  Many of skyfjell's charts wrap flux CRDs. These checks ensure they are installed.
*/}}

{{- if .Values.crdCheck.flux -}}
{{- if not ( .Capabilities.APIVersions.Has "helm.toolkit.fluxcd.io/v2beta1" ) -}}
{{- include "chart.requires" "helm.toolkit.fluxcd.io/v2beta1" -}}
{{- end -}}
{{- end -}}

