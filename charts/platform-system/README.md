# Skyfjell Platform System Helm Chart

The Platform System chart installs core services, configuration between those services, and baseline policies to a Kubernetes cluster.

See a list of [components](#components) below.

Other platform charts:

- [platform-auth](../platform-auth)
- [platform-o11y](../platform-o11y)
- [platform-tenant](../platform-tenant)

See the root [README.md](../../README.md) for other charts in this repository.

## Prerequisites

### Flux

This repository makes heavy use of Flux CRDs for installation.

## Features

### Service Mesh

Istio is installed as service mesh with strict mTLS enabled by default.

A Kyverno policy applies Istio injection to all namespaces not explicitly disabled.

A [`default-deny`](https://istio.io/latest/docs/ops/best-practices/security/#use-default-deny-patterns) `AuthorizationPolicy` is created. You will need to create an `AuthorizationPolicy` for networking between services.

### Policies

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
  name: system
  namespace: flux-system
spec:
  chart:
    spec:
      chart: charts/platform-system
      sourceRef:
        kind: GitRepository
        name: skyfjell
        namespace: flux-system
  interval: 0h10m0s
  values:
    components:
      istio:
        components:
          # Uncomment to enable `externalAuth` for the `platform-auth` chart
          # istiod:
          #   components:
          #     externalAuth:
          #       enabled: true

          # Uncomment to enable a default ingress gateway
          # gateway:
          #   enabled: true
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

For security purposes, some common features are disabled by default.

Complete configuration can be referenced in [`values.yaml`](./values.yaml)

### Enable Ingress

`values`:

```yaml
components:
  istio:
    components:
      gateway:
        enabled: true
```

<details>
  <summary>CLI:</summary>

```shell
$ helm install system skyfjell/platform-system \
  --set="components.istio.components.gateway.enabled=true"
```

</details>

### Enable External Authorization

Note: This creates an extension provider to Istio intended to be used with the [`platform-auth`](../platform-auth/) chart.

`values`:

```yaml
components:
  istio:
    components:
      istiod:
        components:
          externalAuth:
            enabled: true
```

<details>
  <summary>CLI:</summary>

```shell
$ helm install system skyfjell/platform-system \
  --set="components.istio.components.istiod.components.externalAuth.enabled=true"
```

</details>

## Components

### cert-manager [https://cert-manager.io/]()

cert-manager is the default certificate controller for this chart.

### External DNS [https://github.com/kubernetes-sigs/external-dns]()

Automates synchronization of cluster ingress hosts with external DNS providers.

### Istio [https://istio.io/]()

Istio is installed as the default service mesh, providing traffic, security, and policy management.

Istio is installed by default with mTLS enabled and no ingress gateway. An ingress gateway can be created by setting `components.istio.components.gateway.enabled` to `true` in your values. Istio `AuthorizationPolicy` CRD objects are created for communication between the services installed by this chart.

### Kyverno [https://kyverno.io/]()

Kyverno is the default policy engine for the chart.

#### Installed Policies

- Kyverno upstream [kyverno-policies](https://github.com/kyverno/kyverno/tree/main/charts/kyverno-policies) with `podSecurityStandard` set to `restricted` by default
- skyfjell [kyverno-policies](https://github.com/skyfjell/charts/tree/main/charts/kyverno-policies)
  - Enforce Istio Namespace Injection
  - `istio-proxy-quit` for jobs

### MinIO Operator [https://min.io/]()

Operator for creating MinIO tenants. Optionally a default tenant may be created.

### Vault Operator

Secret management and CA. By default a system instance is created.

### Velero [https://velero.io/]()

Cluster backup tool. Supports all major cloud providers, MinIO via the S3 API, CSI, and more.

## API Validation

Validation of the current cluster contexts APIs are performed on installation, template, and upgrade.

⚠️ It's recommended to leave API validation enabled for production. ⚠️

To disable API/CRD validation checks when templating, in development, or for dry runs:

```shell
$ helm template skyfjell/[chart-name] \
  --set"global.skyfjell.validate.api=false"
```
