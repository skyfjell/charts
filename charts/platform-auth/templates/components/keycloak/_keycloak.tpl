{{- define "platform-auth.components.keycloak.values" -}}
{{- $parent := .Values.components.keycloak -}}
{{- $component := $parent.components.server -}}

{{- $nodeSel := merge $.Values.global.nodeSelector $parent.nodeSelector $component.nodeSelector -}}
{{- $tol := default $.Values.global.tolerations ( default $parent.tolerations $component.tolerations ) -}}

{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
fullnameOverride: {{ $parent.name }}
nameOverride: {{ $parent.name }}
serviceAccount:
  name: {{ $parent.name }}
extraEnv: |
  {{- if or $component.admin.username $component.admin.usernameSecretRef }}
  - name: KEYCLOAK_ADMIN
   {{- if $component.admin.usernameSecretRef }}
    valueFrom:
      secretKeyRef: {{- toYaml $component.admin.usernameSecretRef | nindent 8 }}
  {{- else }}
    value: {{ $component.admin.username | quote }}
  {{- end }}
  {{- end }}
  {{- if or $component.admin.password $component.admin.passwordSecretRef }}
  - name: KEYCLOAK_ADMIN_PASSWORD
   {{- if $component.admin.passwordSecretRef }}
    valueFrom:
      secretKeyRef: {{- toYaml $component.admin.passwordSecretRef | nindent 8}}
  {{- else }}
    value: {{ $component.admin.password | quote }}
  {{- end }}
  {{- end }}
  - name: KC_DB_PASSWORD
    valueFrom:
      secretKeyRef:
        key: {{ $parent.components.database.auth.secretKeys.userPasswordKey }}
        name: {{ $parent.components.database.auth.existingSecret }}
  - name: JAVA_OPTS_APPEND
    value: >-
      -XX:+UseContainerSupport
      -XX:MaxRAMPercentage=50.0
      -Djava.awt.headless=true
      -Djgroups.dns.query={{ list $parent.name $parent.components.database.name $ | include "platform-auth.format.name" }}-hl
command:
  - "/opt/keycloak/bin/kc.sh"
  - "--verbose"
  - "start"
  - "--auto-build"
  - "--http-enabled=true"
  - "--http-port=8080"
  - "--hostname-strict=false"
  - "--hostname-strict-https=false"
  - "--spi-events-listener-jboss-logging-success-level=info"
  - "--spi-events-listener-jboss-logging-error-level=warn"
dbchecker:
  enabled: true
database:
  vendor: postgres
  hostname: {{ list $parent.name $parent.components.database.name | include "skyfjell.common.format.name" }}
  port: 5432
  database: {{ $parent.components.database.auth.database }}
  username: {{ $parent.components.database.auth.username }}
{{- end -}}
