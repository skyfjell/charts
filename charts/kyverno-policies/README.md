# Skyfjell Kyverno Policies Helm Chart

A collection of Kyverno policies.

## Policies

### Istio Proxy Quit

Inject the `istio-proxy-quit` container to all `Job`'s to call the `istio-proxy` `/quitquitquit` endpoint when job containers are complete.

### Istio Namespace Injection

Apply `istio-injection=enabled` label to all namespaces unless `istio-injection=disabled` is set.
