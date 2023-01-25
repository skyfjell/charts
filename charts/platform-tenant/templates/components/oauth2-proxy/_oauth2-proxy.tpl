{{/*
  Template for building a oauth2-proxy helm release values
*/}}

{{- define "platform-tenant.app.oauth2-proxy.template" }}
{{ $component := .Values.components.authProxy}}
# used by istio
podLabels:
  version: {{ $component.chart.version}}
nameOverride: {{ list "proxy" . | include "platform-tenant.format.name.shared" }}
# ensures we get correct service name
fullnameOverride: {{ list "proxy" . | include "platform-tenant.format.name.shared" }}
config:
  existingSecret: {{ $component.existingSecret }}
service:
  portNumber: 4180
extraArgs:
  provider: oidc
  provider-display-name: {{ default (list . | include "platform-tenant.format.name.local")  $component.displayName }}
  oidc-issuer-url: {{ $component.issuerUri }}
  # `reverse-proxy: true` forces the application to use `X-Forwarded-For` instead of the `Host` header
  reverse-proxy: true
  # Auth terminates at this application for Istio external auth, only need to return 200 for istio to allow the request to the destination
  upstream: static://200
  # Set the authorization header on the response for istio to pick up and pass to the destination service
  set-authorization-header: true
  email-domain: "*"
  cookie-secure: true
  cookie-samesite: strict
  cookie-refresh: 1h
  cookie-expire: 4h
  cookie-name: {{ printf "_%s_tenant_auth" ( $component.cookieDomain | replace "." "_" | lower ) }}
  cookie-domain: {{ $component.cookieDomain }}
  whitelist-domain: {{ join "," (include "platform-tenant.apps.hosts" . | fromYaml ).hosts | indent 4}}
  # Skip splash link to auth provider
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
