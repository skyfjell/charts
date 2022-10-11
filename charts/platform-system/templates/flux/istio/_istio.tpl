{{ define "platformSystem.istio.repository.name" }}
{{- printf "%s-%s" .Release.Name .Values.apps.istio.chart.source.repository | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{/*
  Istio base templates
*/}}

{{ define "platformSystem.istio.istioBase.release.name" }}
{{- printf "%s-istio-base" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platformSystem.istio.istioBase.defaultValues" -}}
{{- $istioValues := .Values.apps.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
{{- end -}}

{{- define "platformSystem.istio.istioBase.values" }}
{{- $defaultValues := (include "platformSystem.istio.istioBase.defaultValues" $ | fromYaml ) }}
{{- (deepCopy .Values.apps.istio.component.base.values | merge $defaultValues) | toYaml }}
{{- end -}}

{{/*
  Istio discovery templates
*/}}

{{- define "platformSystem.istio.istiod.defaultValues" -}}
{{- $istioValues := .Values.apps.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
pilot:
  podAnnotations: {{ include "helper.appAnnotations" (dict "appAnnotations" .Values.apps.istio.annotations) | indent 4 }}
  nodeSelector: {{ include "helper.nodeSelector" (dict "appNodeSelector" .Values.apps.istio.nodeSelector "globalNodeSelector" .Values.global.nodeSelector ) | indent 4 }}
  tolerations: {{ include "helper.tolerations" (dict "appTolerations" .Values.apps.istio.tolerations "globalTolerations" .Values.global.tolerations ) | indent 4 }}
{{- end -}}

{{ define "platformSystem.istio.istiod.release.name" }}
{{- printf "%s-istiod" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platformSystem.istio.istiod.values" }}
{{- $defaultValues := (include "platformSystem.istio.istiod.defaultValues" $ | fromYaml ) }}
{{- (deepCopy $defaultValues | merge .Values.apps.istio.component.istiod.values) | toYaml }}
{{- end -}}

{{/*
  Istio gateway templates
*/}}

{{ define "platformSystem.istio.istioGateway.release.name" }}
{{- printf "%s-istio-gateway" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platformSystem.istio.istioGateway.defaultValues" -}}
{{- $istioValues := .Values.apps.istio }}
podAnnotations: {{ include "helper.appAnnotations" (dict "appAnnotations" .Values.apps.istio.annotations) | indent 4 }}
nodeSelector: {{ include "helper.nodeSelector" (dict "appNodeSelector" .Values.apps.istio.nodeSelector "globalNodeSelector" .Values.global.nodeSelector ) | indent 4 }}
tolerations: {{ include "helper.tolerations" (dict "appTolerations" .Values.apps.istio.tolerations "globalTolerations" .Values.global.tolerations ) | indent 4 }}
{{- end -}}

{{- define "platformSystem.istio.istioGateway.values" }}
{{- $defaultValues := (include "platformSystem.istio.istioGateway.defaultValues" $ | fromYaml ) }}
{{- (deepCopy $defaultValues | merge .Values.apps.istio.component.gateway.values) | toYaml }}
{{- end -}}