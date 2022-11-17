{{/* 
  Template for building a oauth2-proxy helm release values
*/}}

{{- define "platform-tenant.app.oauth2-proxy.template" }}
{{ $values := .Values.components.oauth2Proxy}}
# used by istio
podLabels:
  version: {{ $values.chart.version}}
nameOverride: {{ include "platform-tenant.proxy.name" . }}
# ensures we get correct service name
fullnameOverride: {{ include "platform-tenant.proxy.name" . }}
config:
  existingSecret: {{ $values.existingSecret }}
extraArgs:
  provider: oidc
  provider-display-name: {{ default (include "platform-tenant.proxy.name" .)  $values.displayName }}
  oidc-issuer-url: {{ $values.oidcIssuerUrl }}
  upstream: static://200
  set-authorization-header: true
  email-domain: "*" 
  cookie-secure: true
  cookie-samesite: strict
  cookie-refresh: 1h
  cookie-expire: 4h
  cookie-name: {{ printf "_%s_tenant_auth" ( $values.cookieDomain | replace "." "_" | lower ) }}
  cookie-domain: {{ $values.cookieDomain }}
  whitelist-domain: {{ join "," (include "platform-tenant.apps.hosts" . | fromYaml ).hosts | indent 4}}
  skip-provider-button: true
replicaCount: 1
resources:
  limits:
    cpu: 200m
    memory: 100Mi
  requests:
    cpu: 100m
    memory: 25Mi
{{- end -}}
