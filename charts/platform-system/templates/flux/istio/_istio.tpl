{{ define "platform-system.istio.repository.name" }}
{{- printf "%s-%s" .Release.Name .Values.apps.istio.chart.source.repository | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
  Istio base templates
*/}}

{{ define "platform-system.istio.istio-base.release.name" }}
{{- printf "%s-istio-base" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.istio.istio-base.defaultValues" -}}
{{- $istioValues := .Values.apps.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
{{- end -}}

{{- define "platform-system.istio.istio-base.values" }}
{{- $defaultValues := (include "platform-system.istio.istio-base.defaultValues" $ | fromYaml ) }}
{{- (deepCopy .Values.apps.istio.component.base.values | merge $defaultValues) | toYaml }}
{{- end -}}

{{/*
  Istio discovery templates
*/}}

{{- define "platform-system.istio.istiod.defaultValues" -}}
{{- $istioValues := .Values.apps.istio }}
global:
  istioNamespace: {{ $istioValues.namespace }}
pilot:
  podAnnotations: {{ include "helper.appAnnotations" (dict "appAnnotations" .Values.apps.istio.annotations) | indent 4 }}
  nodeSelector: {{ include "helper.nodeSelector" (dict "appNodeSelector" .Values.apps.istio.nodeSelector "globalNodeSelector" .Values.global.nodeSelector ) | indent 4 }}
  tolerations: {{ include "helper.tolerations" (dict "appTolerations" .Values.apps.istio.tolerations "globalTolerations" .Values.global.tolerations ) | indent 4 }}
{{- end -}}

{{ define "platform-system.istio.istiod.release.name" }}
{{- printf "%s-istiod" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.istio.istiod.values" }}
{{- $defaultValues := (include "platform-system.istio.istiod.defaultValues" $ | fromYaml ) }}
{{- (deepCopy .Values.apps.istio.component.istiod.values | merge $defaultValues) | toYaml }}
{{- end -}}

{{/*
  Istio gateway templates
*/}}

{{ define "platform-system.istio.istio-gateway.release.name" }}
{{- printf "%s-istio-gateway" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.istio.istio-gateway.defaultValues" -}}
{{- $istioValues := .Values.apps.istio }}
podAnnotations: {{ include "helper.appAnnotations" (dict "appAnnotations" .Values.apps.istio.annotations) | indent 4 }}
nodeSelector: {{ include "helper.nodeSelector" (dict "appNodeSelector" .Values.apps.istio.nodeSelector "globalNodeSelector" .Values.global.nodeSelector ) | indent 4 }}
tolerations: {{ include "helper.tolerations" (dict "appTolerations" .Values.apps.istio.tolerations "globalTolerations" .Values.global.tolerations ) | indent 4 }}
{{- end -}}

{{- define "platform-system.istio.istio-gateway.values" }}
{{- $defaultValues := (include "platform-system.istio.istio-gateway.defaultValues" $ | fromYaml ) }}
{{- (deepCopy .Values.apps.istio.component.gateway.values | merge $defaultValues) | toYaml }}
{{- end -}}