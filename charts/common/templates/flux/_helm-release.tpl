{{- define "skyfjell.common.template.flux.helm-release" -}}
{{- $ := last . -}}
{{- /*
# deepCopy to prevent mutating values
*/ -}}
{{- $component := first . | deepCopy -}}
{{- $component = default (list) $component.ancestorNames | set $component "ancestorNames" -}}

{{- if $component.chart -}}
{{- $name :=  list $component.aggregateName $component.name $ | include (printf "%s.format.name" $.Chart.Name) -}}
{{- $parent := get $component "parent" | default (dict)  -}}
{{- $solution := $.Values.components.flux -}}

{{- $sourceName := default ((($parent).chart).source).name $component.chart.source.name -}}
{{- $repo := get $.Values.components.helmRepositories.components $sourceName -}}

{{- if ($repo).enabled -}}
{{- $sourceName = list $repo.name $ | include (printf "%s.format.name" $.Chart.Name) -}}
{{- end -}}

{{- if and $component.enabled $solution.enabled }}
{{- include "skyfjell.common.require.api.flux.helm-release" $ -}}
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ $name }}
  namespace: {{ $solution.namespace }}
  labels:
    {{- include (printf "%s.labels" $.Chart.Name) $ | nindent 4 }}
    {{- include "skyfjell.common.chartLabels" $ | nindent 4 }}
spec:
  releaseName: {{ $name }}
  targetNamespace: {{ list $component $ | include "skyfjell.common.format.component.namespace" }}
  # TODO: Support local and existing dependsOn
  chart:
    spec:
      chart: {{ default $component.chart.name }}
      version: {{ default $component.chart.version }}
      sourceRef:
        kind: {{ default $component.chart.source.kind }}
        name: {{ $sourceName }}
        namespace: {{ $solution.namespace }}
  interval: {{ default $solution.interval $component.chart.interval }}
  {{/*
  # Include the values template for this component in the depending chart
  # Leave `values` key off of component to disable
  # ex: `define [chart-name].components.[component-name].values`
  # or: `define [chart-name].components.[component-name].components.[component-child-name].values`
  */}}
  {{- if hasKey $component "values" }}
  {{- $valuesTemplate := append $component.ancestorNames $component.name | join ".components." | printf "%s.components.%s.values" $.Chart.Name }}
  values: {{ include $valuesTemplate $ | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}

{{- with $component.components }}
  {{- range $child := . }}
    {{- /*
    # deepCopy to prevent cycle
    */ -}}
    {{- $child = deepCopy $component | set $child "parent" -}}
    {{- $child = set $child "aggregateName" $component.name -}}
    {{- $child = default $component.name $component.namespace $child.namespace | set $child "namespace" -}}
    {{- $child = append $component.ancestorNames $component.name | set $child "ancestorNames" -}}
    {{- list $child $ | include "skyfjell.common.template.flux.helm-release" -}}
  {{- end }}
{{- end }}

{{- end }}
