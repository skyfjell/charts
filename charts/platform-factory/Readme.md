# Skyfjell Platform Factory Helm Chart

The Platform Factory chart offers common applications, configuration between those applications, and baseline policies to a Kubernetes cluster. Works well in Skyfell platform chart stack.

See a list of [components](#components) below.

Other platform charts:

- [platform-auth](../platform-auth)
- [platform-o11y](../platform-o11y)
- [platform-tenant](../platform-tenant)
- [platform-system](../platform-system)

See the root [README.md](../../README.md) for other charts in this repository.

## Prerequisites

In order for the applications to be reached, enable `gateway` in the `platform-system` chart:

```yaml
components:
  istio:
    components:
      gateway:
        enabled: true
```

Most of these applications rely on OIDC integration, refer to [platform-auth](../platform-auth) for keycloak deployment.

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
  name: platform-factory
  namespace: flux-system
spec:
  chart:
    spec:
      chart: platform-factory
      version: "*" # update to desired version
      sourceRef:
        kind: HelmRepository
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

All components are opt-in.

### Privatebin [https://privatebin.info/]()

Host your own private bin instance.

### Jupyterhub [https://github.com/jupyterhub/zero-to-jupyterhub-k8s]()

Jupyterhub helm chart is wrapped with nice to have feature extenstions

#### OIDC Authentication

This component allows for easy OIDC integration with the suggested [GenericAuthenticator](https://github.com/jupyterhub/oauthenticator)

```yaml
jupyterhub:
  auth:
    enabled: false
    realm: ""
    hostname: ""
    clientId:
      key: ""
      name: ""
    clientSecret:
      key: ""
      name: ""
    cryptKey:
      key: ""
      name: ""
    allowedGroups: ["bus_analysts", "data_scientists", "ml_engineers"] # set inside OIDC provider
    claimGroupKey: "groups" # Mapped in OIDC claims
    scope: ["openid", "email", "profile"]
```
