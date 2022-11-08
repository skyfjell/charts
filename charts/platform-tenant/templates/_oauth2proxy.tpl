{{/* 
  Template for building a certificate
*/}}
{{- define "platform-tenant.oauth2-proxy.template" }}
{{ $global := last .}}
{{ $val := first .}}
# used by istio
podLabels:
  version: {{ $global.Values.appAuth.proxy.chart.version}}
nameOverride: {{ $val.name }}
fullnameOverride: {{ $val.name }}
config:
  existingSecret: {{ $val.existingSecret }}
extraArgs:
  provider: oidc
  provider-display-name: {{ $global.Values.appAuth.provider.displayName | quote }}
  oidc-issuer-url: {{ $global.Values.appAuth.provider.oidcIssuerUrl }}
  upstream: static://200
  set-authorization-header: true
  email-domain: "*" 
  cookie-secure: true
  cookie-samesite: lax
  cookie-refresh: 1h
  cookie-expire: 4h
  cookie-name: _mock-1_auth
  cookie-domain: {{ $val.cookieDomain }}
  whitelist-domain: {{ $val.whitelistDomain }}
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