{{/*
Expand the name of the chart.
*/}}
{{- define "platform-tenant.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-tenant.fullname" -}}
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
{{- define "platform-tenant.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-tenant.labels" -}}
helm.sh/chart: {{ include "platform-tenant.chart" . }}
{{ include "platform-tenant.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-tenant.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-tenant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platform-tenant.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platform-tenant.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Set tolerations from global if available and if not set it from app values*/}}  
{{/* ex: tolerations: {{ include "helper.tolerations" (dict "globalTolerations" .Values.global.tolerations "appTolerations" .Values.apps.<app>.tolerations ) | indent 6 }} */}}
{{- define "helper.tolerations" }}                                                   
{{- if .appTolerations }}                                                            
{{ toYaml .appTolerations | indent 2 }}                                              
{{- else if .globalTolerations }}                                                    
{{ toYaml .globalTolerations | indent 2 }}                                           
{{- else }}                                                                          
{{- "[]" }}                                                                          
{{- end }}                                                                           
{{- end }}                                                                           
                                                                                     
{{/* Set nodeSelector from global if available and if not set it from app values*/}} 
{{/* ex: nodeSelector: {{ include "helper.nodeSelector" (dict "globalNodeSelector" .Values.global.nodeSelector "appNodeSelector" .Values.apps.<app>.nodeSelector) | indent 6 }} */}}
{{- define "helper.nodeSelector" }}                                                  
{{- if .appNodeSelector }}                                                           
{{ toYaml .appNodeSelector | indent 2 }}                                             
{{- else if .globalNodeSelector }}                                                   
{{ toYaml .globalNodeSelector | indent 2 }}                                          
{{- else }}                                                                          
{{- "{}" }}                                                                          
{{- end }}                                                                           
{{- end }}                                                                           
