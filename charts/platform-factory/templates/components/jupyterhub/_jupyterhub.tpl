{{/* Hub component, we only configure the auth components here */}}
{{- define "platform-factory.components.jupyterhub.components.hub.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.jupyterhub -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector  -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $labels := merge $global.labels $component.labels  -}}

{{- with $anno }}
annotations:
  {{- toYaml . | nindent 2  }}
{{- end }}
{{- with $labels }}
labels:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- $auth := $component.auth }}
{{- if $auth.enabled }}
extraEnv:
  OAUTH_CLIENT_SECRET:
    valueFrom:
      secretKeyRef:
        {{- toYaml $auth.clientSecret | nindent 10 }}
  OAUTH_CLIENT_ID:
    valueFrom:
      secretKeyRef:
        {{- toYaml $auth.clientId | nindent 10 }}
  JUPYTERHUB_CRYPT_KEY:
    valueFrom:
      secretKeyRef:
        {{- toYaml $auth.cryptKey | nindent 10 }}
{{- $authConfig := omit $auth "cryptKey" "clientId" "clientSecret" "enabled" }}
config:
  JupyterHub:
    authenticator_class: generic-oauth
  GenericOAuthenticator:
    oauth_callback_url: {{ printf "https://%s/hub/oauth_callback" .Values.components.jupyterhub.host }}
    {{ with $authConfig }}
    {{ toYaml . | nindent 4 }}  
    {{ end }}
{{- end }}
{{- end -}}

{{/* Proxy component, we only alter metadata/scheduling in this parent chart */}}
{{- define "platform-factory.components.jupyterhub.components.proxy.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.jupyterhub -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector  -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $labels := merge $global.labels $component.labels  -}}
service:
  type: ClusterIP
{{- with $labels }}
labels:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $anno }}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{ if or $tol $nodeSel }}
chp:
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- if or $tol $nodeSel $labels }}
traefik:
  {{- with $labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}


{{/* prePuller component, we only alter metadata/scheduling in this parent chart */}}
{{- define "platform-factory.components.jupyterhub.components.prePuller.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.jupyterhub -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}
{{- $labels := merge $global.labels $component.labels -}}

{{- with $labels }}
labels:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $anno }}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{ if or $nodeSel $tol }}
hook:
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/* scheduling component, we only alter metadata/scheduling in this parent chart */}}
{{- define "platform-factory.components.jupyterhub.components.scheduling.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.jupyterhub -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}
{{- $labels := merge $global.labels $component.labels -}}
{{ if or $nodeSel $tol $anno $labels }}
userScheduler:
  {{- with $tol }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $nodeSel }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $anno }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/* Singleuser component, we only alter metadata/scheduling in this parent chart */}}
{{- define "platform-factory.components.jupyterhub.components.singleuser.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.jupyterhub -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}
{{- $labels := merge $global.labels $component.labels -}}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- with $labels }}
labels:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- with $anno }}
annotations:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}

{{- define "platform-factory.components.jupyterhub.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.jupyterhub -}}

{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := merge $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}
{{- $labels := merge $global.labels $component.labels -}}

fullnameOverride: {{ $component.name }}
nameOverride: {{ $component.name }}
{{ with (include "platform-factory.components.jupyterhub.components.hub.defaultValues" . | fromYaml) }}
hub: {{-  toYaml . | nindent 2 }}
{{- end -}}
{{ with (include "platform-factory.components.jupyterhub.components.proxy.defaultValues" . | fromYaml) }}
proxy: {{- toYaml . | nindent 2 }}
{{- end -}}
{{ with (include "platform-factory.components.jupyterhub.components.prePuller.defaultValues" . | fromYaml) }}
prePuller: {{- toYaml . | nindent 2 }}
{{- end -}}
{{ with (include "platform-factory.components.jupyterhub.components.singleuser.defaultValues" . | fromYaml) }}
singleuser: {{- toYaml . | nindent 2 }}
{{- end -}}
{{ with (include "platform-factory.components.jupyterhub.components.scheduling.defaultValues" . | fromYaml) }}
scheduling: {{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}