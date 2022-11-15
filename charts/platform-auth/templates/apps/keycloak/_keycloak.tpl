{{- define "platform-auth.components.keycloak.values" -}}
{{ $component := .Values.components.keycloak }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{ toYaml . | indent 2}}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
{{ range .Values.tolerations }}
  - {{ .  | quote}}
{{- end }}
{{- end }}
fullnameOverride: {{ list $component.name $ | include "platform-auth.format.name" }}
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
        key: {{ $component.components.database.auth.secretKeys.userPasswordKey }}
        name: {{ $component.components.database.auth.existingSecret }}
  - name: JAVA_OPTS_APPEND
    value: >-
      -XX:+UseContainerSupport
      -XX:MaxRAMPercentage=50.0
      -Djava.awt.headless=true
      -Djgroups.dns.query={{ list $component.name $component.components.database.name $ | include "platform-auth.format.name" }}-hl
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
  hostname: {{ list $component.name $component.components.database.name $ | include "platform-auth.format.name" }}
  port: 5432
  database: {{ $component.components.database.auth.database }}
  username: {{ $component.components.database.auth.username }}
{{- end -}}