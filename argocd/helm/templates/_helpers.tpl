{{- define "argocd.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "argocd.fullname" -}}
{{- .Release.Name }}-{{ .Chart.Name }}
{{- end -}}

{{- define "argocd.namespace" -}}
{{ .Release.Namespace }}
{{- end -}}
