{{/*
  Many of skyfjell's charts wrap kyverno CRDs. These checks ensure they are installed.
*/}}

{{/* Error message */}}
{{ define "skyfjell.common.require.api.kyverno.message" }}
  {{- "Kyverno is installed as a part of the Platform System chart: https://github.com/skyfjell/charts/tree/main/charts/platform-system" -}}
  {{- "\n" -}}
  {{- "Or to install Kyverno: https://kyverno.io/docs/installation" -}}
{{ end }}

{{/*
  Checks generally if API version for kyverno is installed. Currently only checking require CRDs.
*/}}
{{ define "skyfjell.common.require.api.kyverno.cluster-policy" }}
  {{ include "skyfjell.common.require.api.kyverno.base" ( list "kyverno.io" "ClusterPolicy" $ ) }}
{{end}}

{{ define "skyfjell.common.require.api.kyverno.policy" }}
  {{ include "skyfjell.common.require.api.kyverno.base" ( list "kyverno.io" "Policy" $ ) }}
{{end}}


{{ define "skyfjell.common.require.api.kyverno.all" }}
  {{ include "skyfjell.common.require.api.kyverno.cluster-policy" . }}
  {{ include "skyfjell.common.require.api.kyverno.policy" . }}
{{ end }}


{{/*
  Checks specifically for a kyverno api version and resource.

  Use like `{{ include "skyfjell.common.require.api.kyverno.base" ( list "kyverno.io" "ClusterPolicy" $) }}`
*/}}
{{- define "skyfjell.common.require.api.kyverno.base" }}
  {{- include "skyfjell.common.require.api.kyverno.message" . | prepend . | include "skyfjell.common.require.api" -}}
{{- end -}}
