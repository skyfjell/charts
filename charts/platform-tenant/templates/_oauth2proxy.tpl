{{/* 
  Template for building a certificate
*/}}
{{- define "platform-tenant.app.oauth2-proxy.template" }}
{{ $values := .Values.appAuth.proxy}}
# used by istio
podLabels:
  version: {{ $values.chart.version}}
nameOverride: {{ include "platform-system.helper.proxyName" $ }}
# ensures we get correct service name
fullnameOverride: {{ include "platform-system.helper.proxyName" $ }}
config:
  existingSecret: {{ $values.existingSecret }}
extraArgs:
  provider: oidc
  provider-display-name: {{ default (include "platform-system.helper.proxyName" $)  $values.displayName }}
  oidc-issuer-url: {{ $values.oidcIssuerUrl }}
  upstream: static://200
  set-authorization-header: true
  email-domain: "*" 
  cookie-secure: true
  cookie-samesite: lax
  cookie-refresh: 1h
  cookie-expire: 4h
  cookie-name: _mock-1_auth
  cookie-domain: {{ $values.cookieDomain }}
  whitelist-domain: {{ $values.whitelistDomain }}
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
