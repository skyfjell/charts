{{/*
Expand the name of the chart.
*/}}
{{- define "platformSystem.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platformSystem.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "platformSystem.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platformSystem.labels" -}}
helm.sh/chart: {{ include "platformSystem.chart" . }}
{{ include "platformSystem.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platformSystem.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platformSystem.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platformSystem.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platformSystem.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Set tolerations from global if available and if not set it from app values*/}}  
{{/* ex: tolerations: {{ include "helper.tolerations" (dict "globalTolerations" .Values.global.tolerations "appTolerations" .Values.components.<app>.tolerations ) }} */}}
{{- define "helper.tolerations" }}                                                   
{{- if .appTolerations }}                                                            
{{ toYaml .appTolerations }}                                              
{{- else if .globalTolerations }}                                                    
{{ toYaml .globalTolerations }}                                           
{{- else }}                                                                          
{{- "[]" }}                                                                          
{{- end }}                                                                           
{{- end }}                                                                           



{{/*
Sets annotations for app based on local and global annoations.
Ex: {{ include "platformSystem.helper.annotations" (list "kyverno" $)}}
*/}}
{{- define "platformSystem.helper.annotations" }}
{{- $path:= first .}}
{{- $global := last . }}
{{- $values := $global.Values }}
{{- $appName :=  ((tpl (printf "{{ default dict ( $.Values.components.%s).annotations | toYaml }}" $path) $global) | fromYaml) }}
{{- with (default $values.global.annotations $appName ) }}
annotations: {{- toYaml . | nindent 2}}
{{- end -}}
{{- end -}}

{{/*
Sets nodeSelector for app based on local and global nodeSelector.
Ex: {{ include "platformSystem.helper.nodeSelector" (list "kyverno" $)}}
*/}}
{{- define "platformSystem.helper.nodeSelector" }}
{{- $path := first .}}
{{- $global := last . }}
{{- $values := $global.Values }}
{{- $appName :=  ((tpl (printf "{{ default dict ( $.Values.components.%s).nodeSelector | toYaml }}" $path) $global) | fromYaml) }}
{{- with (default $values.global.nodeSelector $appName ) }}
nodeSelector: {{- toYaml . | nindent 2}}
{{- end -}}
{{- end -}}

{{/*
Sets tolerations for app based on local and global tolerations.
Ex: {{ include "platformSystem.helper.tolerations" (list "kyverno" $)}}
*/}}
{{- define "platformSystem.helper.tolerations" }}
{{- $path:= first .}}
{{- $global := last . }}
{{- $values := $global.Values }}
{{- $appName :=  ((tpl (printf "{{ default dict ( $.Values.components.%s).tolerations | toYaml }}" $path) $global) | fromYaml) }}
{{- with (default $values.global.tolerations $appName ) }}
tolerations: {{- toYaml . | nindent 2}}
{{- end -}}
{{- end -}}


{{/* Set nodeSelector from global if available and if not set it from app values*/}} 
{{/* ex: nodeSelector: {{ include "helper.nodeSelector" (dict "globalNodeSelector" .Values.global.nodeSelector "appNodeSelector" .Values.components.<app>.nodeSelector) }} */}}
{{- define "helper.nodeSelector" }}                                                  
{{- if .appNodeSelector }}                                                           
{{ toYaml .appNodeSelector }}                                             
{{- else if .globalNodeSelector }}                                                   
{{ toYaml .globalNodeSelector }}                                          
{{- else }}                                                                          
{{- "{}" }}                                                                          
{{- end }}                                                                           
{{- end }}                                                                           

{{/* Set annotations in subcharts from main chart */}}
{{/* ex: annotations: {{ include "helper.appAnnotations" ("appAnnotations" .Values.components.<app>.appAnnotations) }} */}}
{{- define "helper.appAnnotations" }}
{{- if .appAnnotations }}
{{ toYaml .appAnnotations }}
{{- else }}
{{- "{}" }}
{{- end }}
{{- end }}

{{/* Set annotations in subcharts from main chart */}}
{{/* ex: annotations: {{ include "helper.saAnnotations" ("saAnnotations" .Values.components.<app>.serviceAccountAnnotations) }} */}}
{{- define "helper.saAnnotations" }}
{{- if .saAnnotations }}
{{ toYaml .saAnnotations }}
{{- else }}
{{- "{}" }}
{{- end }}
{{- end }}

{{/* Pass the storage class name through from main chart */}}
{{/* ex: key: {{ include "helper.storageClassName" ("scname" .Values.components.<app>.storageClassName) }} */}}
{{- define "helper.storageClassName" }}
{{- if .scname }}
{{- toYaml .scname -}}
{{- else }}
{{- "default" }}
{{- end }}
{{- end }}

