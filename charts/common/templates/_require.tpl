{{/*
  Checks specifically for a CRD api version and resource.

  Use like `{{ include "require.api" ( list "errorMessage.flux" "helm.toolkit.fluxcd.io" "HelmRelease" $) }}`
*/}}
{{- define "require.api" }}
  {{- $global :=  ( last . ) }}
  {{- $tpl := (first . ) }}
  {{- $api := ( first ( rest . ) ) }}
  {{- $kind := ( last ( initial . ) ) }}  
  {{- $flag := dict "flag" "false" }}
  {{- range $installed := $global.Capabilities.APIVersions }}
    {{- $matchApi := (hasPrefix ( printf "%s/" $api ) $installed ) }}
    {{- $matchKind := (hasSuffix ( printf "/%s" $kind ) $installed )}}
    {{-  if (and $matchApi $matchKind) }}
      {{- $_ := set $flag "flag" "true" }}
    {{- end }}
  {{- end }}
  {{- if not ( eq ( get $flag "flag" ) "true" ) }}
   {{- include $tpl (printf "kind of '%s' from '%s'" $kind $api ) -}}
  {{- end }}
{{- end -}}


