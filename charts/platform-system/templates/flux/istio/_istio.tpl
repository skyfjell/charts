{{ define "platform-system.components.istio.repository.name" }}
{{- printf "%s-%s" .Release.Name .Values.components.istio.chart.source.repository | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{/*
  Istio base templates
*/}}

{{ define "platform-system.components.istio.components.base.release.name" }}
{{- printf "%s-istio-base" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.components.istio.components.base.defaultValues" -}}
{{- $istioValues := .Values.components.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
{{- end -}}

{{- define "platform-system.components.istio.components.base.values" }}
{{- $defaultValues := (include "platform-system.components.istio.components.base.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.components.base.values ) | toYaml }}
{{- end -}}

{{/*
  Istio discovery templates
*/}}

{{- define "platform-system.components.istio.components.istiod.defaultValues" -}}
{{- $istioValues := .Values.components.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
{{- $anno := ( include "platform-system.helper.annotations" ( list "istiod" $ ) ) }}
{{- $tol := ( include "platform-system.helper.tolerations" ( list "istiod" $ ) ) }}
{{- $sel := ( include "platform-system.helper.nodeSelector" ( list "istiod" $ ) ) }}
{{- if or (or $anno $tol) $sel }}
pilot:
  {{- with $anno }}
  podAnnotations:
    {{ . | indent 4 }}
  {{- end }}
  {{- with $sel }}
  nodeSelector:
    {{ . | indent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 2 }}
  {{- end }}
{{- end -}}
{{- end -}}

{{ define "platform-system.components.istio.components.istiod.release.name" }}
{{- printf "%s-istiod" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.components.istio.components.istiod.values" }}
{{- $defaultValues := (include "platform-system.components.istio.components.istiod.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.components.istiod.values ) | toYaml }}
{{- end -}}

{{/*
  Istio gateway templates
*/}}

{{ define "platform-system.components.istio.components.gateway.release.name" }}
{{- printf "%s-istio-gateway" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.components.istio.components.gateway.defaultValues" -}}
{{ $parent := .Values.components.istio }}
{{ $component := $parent.components.gateway }}
name: {{ list $component.name $ | include "platform-system.format.name" }}

{{- $tol := ( include "platform-system.helper.tolerations" ( list "istioGateway" $ ) ) }}
{{- $sel := ( include "platform-system.helper.nodeSelector" ( list "istioGateway" $ ) ) }}
{{- with $sel }}
nodeSelector:
  {{ . | indent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{ . }}
{{- end }}

{{- end -}}

{{- define "platform-system.components.istio.components.gateway.values" }}
{{- $defaultValues := (include "platform-system.components.istio.components.gateway.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.components.gateway.values ) | toYaml }}
{{- end -}}