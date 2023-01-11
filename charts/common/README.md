# Skyfjell Platform Common Helm Library Chart

Common templates for other skyfjell charts.

Provides:

- Common formatting
- Kubernetes API/CRD validation

## API Validation

Validation of the current cluster contexts APIs are performed on installation, template, and upgrade.

⚠️ It's recommended to leave API validation enabled for production. ⚠️

To disable API/CRD validation checks when templating, in development, or for dry runs:

```shell
$ helm template skyfjell/[chart-name] \
  --set"global.skyfjell.validate.api=false"
```
