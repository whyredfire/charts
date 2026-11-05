{{- define "mysql.labels" -}}
app.kubernetes.io/name: mysql
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mysql.secretName" -}}
{{- .Values.auth.existingSecret | default .Release.Name }}
{{- end }}
