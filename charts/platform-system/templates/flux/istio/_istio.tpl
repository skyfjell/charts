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
{{- $component := .Values.components.istio }}
global:
  istioNamespace: {{ $component.namespace }}
{{- end -}}

{{- define "platform-system.components.istio.components.base.values" }}
{{- $defaultValues := (include "platform-system.components.istio.components.base.defaultValues" $ | fromYaml ) }}
{{- ( mergeOverwrite $defaultValues .Values.components.istio.components.base.values ) | toYaml }}
{{- end -}}

{{/*
  Istio discovery templates
*/}}

{{- define "platform-system.components.istio.components.istiod.defaultValues" -}}
{{- $component := .Values.components.istio }}
global:
  istioNamespace: {{ $component.namespace }}
{{ $anno := list "istiod" $ | include "platform-system.helper.annotations" }}
{{ $tol := list "istiod" $ | include "platform-system.helper.tolerations" }}
{{ $sel := list "istiod" $ | include "platform-system.helper.nodeSelector" }}
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
meshConfig:
  enablePrometheusMerge: true
  enableTracing: true
  defaultConfig:
    proxyMetadata:
      # Enable basic DNS proxying
      ISTIO_META_DNS_CAPTURE: "true"
      # Enable automatic address allocation
      ISTIO_META_DNS_AUTO_ALLOCATE: "true"
{{- $externalAuth := $component.components.istiod.components.externalAuth -}}
{{- if $externalAuth.enabled }}
  extensionProviders:
    - name: {{ $externalAuth.name }}
      envoyExtAuthzHttp:
        service: {{ $externalAuth.service }}
        port: {{ $externalAuth.port }}
        headersToUpstreamOnAllow:
          - authorization
        headersToDownstreamOnDeny:
          - set-cookie
        includeRequestHeadersInCheck:
          - cookie
        includeAdditionalHeadersInCheck:
          # Optional for oauth2-proxy to enforce https
          # X-Auth-Request-Redirect: "https://%REQ(:authority)%%REQ(:path)%"
          X-Forwarded-Host: "%REQ(:authority)%"
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
