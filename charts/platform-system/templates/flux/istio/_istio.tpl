{{ define "platformSystem.istio.repository.name" }}
{{- printf "%s-%s" .Release.Name .Values.components.istio.chart.source.repository | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{/*
  Istio base templates
*/}}

{{ define "platformSystem.istio.istioBase.release.name" }}
{{- printf "%s-istio-base" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platformSystem.istio.istioBase.defaultValues" -}}
{{- $istioValues := .Values.components.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
{{- end -}}

{{- define "platformSystem.istio.istioBase.values" }}
{{- $defaultValues := (include "platformSystem.istio.istioBase.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.component.base.values ) | toYaml }}
{{- end -}}

{{/*
  Istio discovery templates
*/}}

{{- define "platformSystem.istio.istiod.defaultValues" -}}
{{- $istioValues := .Values.components.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
{{- $anno := ( include "platformSystem.helper.annotations" ( list "istiod" $ ) ) }}
{{- $tol := ( include "platformSystem.helper.tolerations" ( list "istiod" $ ) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" ( list "istiod" $ ) ) }}
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

{{ define "platformSystem.istio.istiod.release.name" }}
{{- printf "%s-istiod" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platformSystem.istio.istiod.values" }}
{{- $defaultValues := (include "platformSystem.istio.istiod.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.component.istiod.values ) | toYaml }}
{{- end -}}

{{/*
  Istio gateway templates
*/}}

{{ define "platformSystem.istio.istioGateway.release.name" }}
{{- printf "%s-istio-gateway" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platformSystem.istio.istioGateway.defaultValues" -}}
{{- $tol := ( include "platformSystem.helper.tolerations" ( list "istioGateway" $ ) ) }}
{{- $sel := ( include "platformSystem.helper.nodeSelector" ( list "istioGateway" $ ) ) }}
{{- with $sel }}
nodeSelector:
  {{ . | indent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{ . }}
{{- end }}
{{- end -}}

{{- define "platformSystem.istio.istioGateway.values" }}
{{- $defaultValues := (include "platformSystem.istio.istioGateway.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.component.gateway.values ) | toYaml }}
{{- end -}}