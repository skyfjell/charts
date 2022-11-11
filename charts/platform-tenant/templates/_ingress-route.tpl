{{/* 
  Template for building a traefik IngressRoute
*/}}
{{- define "platform-tenant.app.ingress-route.template" -}}
{{- $global := last . }}
{{- $val := first . }}
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: {{ printf "%s-ingress-route" $val.name | quote }}
  namespace: {{ $global.Values.targetNamespace.name | quote }}
  labels: {{- include "skyfjell.common.chartLabels" $global | nindent 4 }}
    app.kubernetes.io/name: traefik
    app.kubernetes.io/instance: platform-auth-auth-proxy
spec:
  entryPoints:
    - web
  routes:
    - kind: Rule
      match: {{ printf "Headers(`X-Forwarded-Host`, `%s`)" $val.url }}
      services:
        - name: {{ include "platform-system.helper.proxyName" $global }}
          port: 80
{{- end -}}