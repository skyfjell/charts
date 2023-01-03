{{ define "platform-system.components.velero.defaultValues.aws" }}
{{- $ := . -}}
{{- $component := $.Values.components.velero -}}
{{- $aws := $component.provider.aws -}}
initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.5.2
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - name: plugins
        mountPath: /target
configuration:
  provider: aws
  backupStorageLocation:
    bucket: {{ $aws.bucket }}
    config:
      region: {{ $aws.region }}
      {{- if $aws.s3Url }}
      s3Url: {{ $aws.s3Url }}
      {{- else }}
      s3Url: {{ printf "https://s3.%s.amazonaws.com" $aws.region }}
      {{- end }}
      {{- with $aws.kmsKeyId }}
      kmsKeyId: {{ . }}
      {{- end }}
  volumeSnapshotLocation:
    config:
      region: {{ $aws.region }}  
{{- end -}}

{{- define "platform-system.components.velero.defaultValues" -}}
{{- $ := . -}}
{{- $global := $.Values.global -}}
{{- $component := $.Values.components.velero -}}
{{- $anno := merge $global.annotations $component.annotations -}}
{{- $nodeSel := default $global.nodeSelector $component.nodeSelector -}}
{{- $tol := default $global.tolerations $component.tolerations -}}
{{- $aff := default $global.affinity $component.affinity  -}}
{{- with $nodeSel }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $tol }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $anno }}
podAnnotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $aff }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
credentials:
  useSecret: false
{{- if (gt ( keys $component.provider | len ) 1) }}
{{ fail "Only one provider configuration can be set."}}
{{- end }}
{{- if (hasKey $component.provider "aws") }}
{{ include "platform-system.components.velero.defaultValues.aws" $  }}
{{- end -}}
{{- end -}}