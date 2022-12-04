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
{{- $parent := .Values.components.istio }}
global:
  istioNamespace: {{ list $parent $ | include "skyfjell.common.format.component.namespace" }}
{{- end -}}

{{- define "platform-system.components.istio.components.base.values" }}
{{- $defaultValues := (include "platform-system.components.istio.components.base.defaultValues" $ | fromYaml ) }}
{{- mergeOverwrite $defaultValues .Values.components.istio.components.base.values | toYaml }}
{{- end -}}

{{/*
  Istio discovery templates
*/}}

{{- define "platform-system.components.istio.components.istiod.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $parent := $.Values.components.istio -}}
{{- $component := $parent.components.istiod -}}

{{- $anno := merge $global.annotations $parent.annotations $component.annotations -}}
{{- $nodeSel := default $global.nodeSelector $parent.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $parent.tolerations $component.tolerations -}}

global:
  istioNamespace: {{ list $parent $ | include "skyfjell.common.format.component.namespace" }}
{{- if or $anno $nodeSel $tol }}
pilot:
  {{- with $anno }}
  podAnnotations:
    {{ . | indent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{ . | indent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{ . | indent 4 }}
  {{- end }}
{{- end }}
meshConfig:
  enablePrometheusMerge: true
  enableTracing: true
  defaultConfig:
    proxyMetadata:
      # Enable basic DNS proxying
      ISTIO_META_DNS_CAPTURE: "true"
      # Enable automatic address allocation
      ISTIO_META_DNS_AUTO_ALLOCATE: "true"
{{- $externalAuth := $component.components.externalAuth -}}
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
{{- mergeOverwrite $defaultValues .Values.components.istio.components.istiod.values | toYaml }}
{{- end -}}

{{/*
  Istio gateway templates
*/}}

{{ define "platform-system.components.istio.components.gateway.release.name" }}
{{- printf "%s-istio-gateway" .Release.Name | replace "+" "_" | trimSuffix "-" }}
{{- end -}}

{{- define "platform-system.components.istio.components.gateway.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.global -}}
{{- $parent := $.Values.components.istio -}}
{{- $component := $parent.components.gateway -}}

{{- $anno := merge $global.annotations $parent.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $parent.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $parent.tolerations $component.tolerations -}}

name: {{ $component.name }}

{{- with $nodeSel }}
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
{{- mergeOverwrite $defaultValues .Values.components.istio.components.gateway.values | toYaml }}
{{- end -}}
