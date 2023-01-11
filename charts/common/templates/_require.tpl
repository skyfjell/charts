{{/*
  Validate the existence of a Kubernetes API/CRD object and version.
*/}}
{{- define "skyfjell.common.require.api.check" -}}
  {{- $ :=  last . -}}
  {{- $api := first . -}}
  {{- $kind := rest . | first -}}
  {{- range $installed := $.Capabilities.APIVersions -}}
    {{- $matchApi := hasPrefix ( printf "%s/" $api ) $installed -}}
    {{- $matchKind := hasSuffix ( printf "/%s" $kind ) $installed -}}
    {{- if and $matchApi $matchKind -}}
      {{- "true" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
  Validate the existence of a Kubernetes API/CRD object and version.

  Usage: `{{ list "Flux not installed" "helm.toolkit.fluxcd.io" "HelmRelease" $ | include "skyfjell.common.require.api" }}`
*/}}
{{- define "skyfjell.common.require.api" }}
  {{- $ :=  last . -}}
  {{- $apiMessage := first . -}}
  {{- $api := rest . | first -}}
  {{- $kind := initial . | last -}}
  {{- $helpMessage := "To disable these checks see: https://github.com/skyfjell/charts/tree/main/charts/common/README.md#api-validation" -}}

  {{- $valid := list $api $kind $ | include "skyfjell.common.require.api.check" -}}
  {{- $valid := eq $valid "true" -}}
  {{- $enabled := ((($.Values.global).skyfjell).validate).api -}}

  {{- if ne $enabled false -}}
    {{- if eq $valid false -}}
      {{- $message := printf "\n\nMissing API: `%s` from `%s`\n\n%s\n\n%s" $kind $api $apiMessage $helpMessage -}}
      {{- fail $message -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
