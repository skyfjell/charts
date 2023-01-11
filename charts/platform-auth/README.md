# Skyfjell Platform Auth Helm Chart

The Platform Auth chart installs authn/authz services, and configuration between those services and system(`platform-system`) services.

This chart depends strongly on the [Platform System](../platform-system) chart.

See a list of [components](#components) below.

Other platform charts:

- [platform-system](../platform-system)
- [platform-o11y](../platform-o11y)
- [platform-tenant](../platform-tenant)

See the root [README.md](../../README.md) for other charts in this repository.

## Prerequisites

In order for the Traefik auth proxy to function, enable `externalAuth` in the `platform-system` chart:

```yaml
components:
  istio:
    components:
      istiod:
        components:
          externalAuth:
            enabled: true
```

## Installation

### With Flux

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: HelmRepository
metadata:
  name: skyfjell
  namespace: flux-system
spec:
  url: https://charts.skyfjell.io/
  interval: 1m
```

```yaml
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: platform-auth
  namespace: flux-system
spec:
  chart:
    spec:
      chart: charts/platform-auth
      sourceRef:
        kind: GitRepository
        name: skyfjell
        namespace: flux-system
  interval: 0h10m0s
```

### CLI

Add the skyfjell repo if necessary:

```shell
$ helm repo add skyfjell https://charts.skyfjell.io
$ helm repo update
```

Basic installation:

```shell
$ helm install system skyfjell/platform-system
```

## Configuration

## Components

### Keycloak [https://www.keycloak.org/]()

Keycloak is installed as the default identity provider.

### Traefik [https://traefik.io/]()

Traefik is leveraged as a proxy for Istio external auth for applications within the cluster/mesh using instances of [`oauth2-proxy`](https://github.com/oauth2-proxy/oauth2-proxy).

When enabled in `platform-system`, an Istio `AuthorizationPolicy` with the `CUSTOM` provider set to `platform-auth-proxy`(default value) points to the Traefik service which then proxies to the `oauth2-proxy` matching hosts for the application.

The [`platform-tenant`](../platform-tenant/) chart abstracts these concepts by:

- Installing an `oauth2-proxy` instance for the tenant namespace
- Creating `AuthorizationPolicy` objects for the namespace and tenant hosts
- Creating a Traefik `IngressRoute` to proxy requests for hosts to the appropriate `oauth2-proxy` instance

To use the traefik proxy for other services:

First, install `oauth2-proxy` in the namespace, configured with the client details for the app.

Configure a `CUSTOM` authorization policy. The provider is configured in `platform-system` via `externalAuth` flag on `istiod` component.

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: custom-host-auth
  namespace: system-istio
spec:
  selector:
    matchLabels:
      istio: system-istio-gateway
  action: CUSTOM
  provider:
    name: platform-auth-proxy
  rules:
    - to:
        - operation:
            hosts:
              - my-app.example.com
            ports:
              - "443"
              - "80"
```

Otherwise allow traffic to the gateway for the host:

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-host
  namespace: system-istio
spec:
  action: ALLOW
  selector:
    matchLabels:
      istio: system-istio-gateway
  rules:
    - to:
        - operation:
            hosts:
              - my-app.example.com
            ports:
              - "443"
              - "80"
```

Allow traffic from the gateway to the application:

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-host-my-app
  namespace: my-app
spec:
  selector:
    matchLabels:
      app: my-app
  rules:
    - from:
        - source:
            namespaces:
              - system-istio-gateway
            principals:
              - cluster.local/ns/system-istio-gateway/sa/system-istio-gateway-istio-gateway
      to:
        - operation:
            hosts:
              - my-app.example.com
```

Rewrite the host header for the proxy to the app `oauth2-proxy` instance.

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: host-header
  namespace: my-app
spec:
  headers:
    customRequestHeaders:
      Host: oauth2-proxy.my-app.svc
      X-Forwarded-Proto: https
```

Create an `IngressRoute` telling Traefik to proxy requests for the application host to the correct `oauth2-proxy` instance.

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: my-app
  namespace: my-app
spec:
  entryPoints:
    - web
  routes:
    - kind: Rule
      match: Headers(`X-Forwarded-Host`, `my-app.example.com`)
      middlewares:
        - name: host-header
      services:
        - kind: Service
          name: oauth2-proxy
          namespace: my-app
          port: 4180
```
