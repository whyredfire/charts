{{/* vim: set filetype=mustache: */}}

{{- define "config-redis.conf" }}
{{- if .Values.redis.customConfig }}
{{ tpl .Values.redis.customConfig . | indent 4 }}
{{- else }}
    dir "/data"
    port {{ .Values.redis.port }}
    {{- if .Values.redis.tlsPort }}
    tls-port {{ .Values.redis.tlsPort }}
    tls-cert-file /tls-certs/{{ .Values.tls.certFile }}
    tls-key-file /tls-certs/{{ .Values.tls.keyFile }}
    {{- if .Values.tls.dhParamsFile }}
    tls-dh-params-file /tls-certs/{{ .Values.tls.dhParamsFile }}
    {{- end }}
    {{- if .Values.tls.caCertFile }}
    tls-ca-cert-file /tls-certs/{{ .Values.tls.caCertFile }}
    {{- end }}
    {{- if eq (default "yes" .Values.redis.authClients) "no"}}
    tls-auth-clients no
    {{- end }}
    {{- end }}
    {{- if .Values.redis.disableCommands }}
    {{- range .Values.redis.disableCommands }}
    rename-command {{ . }} ""
    {{- end }}
    {{- end }}
    {{- range $key, $value := .Values.redis.config }}
    {{- if kindIs "slice" $value }}
        {{- range $value }}
    {{ $key }} {{ . }}
        {{- end }}
        {{- else }}
    {{ $key }} {{ $value }}
        {{- end }}
    {{- end }}
{{- if .Values.auth }}
    requirepass replace-default-auth
{{- end }}
{{- end }}
{{- end }}

{{- define "config-init.sh" }}
    echo "$(date) Start..."
    set -eu

    REDIS_CONF=/data/conf/redis.conf

    mkdir -p /data/conf/
    echo "Copying default redis config.."
    echo "  to '${REDIS_CONF}'"
    cp /readonly-config/redis.conf "${REDIS_CONF}"

    if [ "${AUTH:-}" ]; then
        echo "Setting redis auth values.."
        ESCAPED_AUTH=$(echo "${AUTH}" | sed -e 's/[\/&]/\\&/g');
        sed -i "s/replace-default-auth/${ESCAPED_AUTH}/" "${REDIS_CONF}"
    fi

    echo "$(date) Ready..."
{{- end }}

{{- define "redis-cli-options" }}
      {{- if .Values.auth }}
        -a "${AUTH}" --no-auth-warning \
      {{- end }}
        -h localhost \
      {{- if ne (int .Values.redis.port) 0 }}
        -p {{ .Values.redis.port }} \
      {{- else }}
        -p {{ .Values.redis.tlsPort }} --tls --cacert /tls-certs/{{ .Values.tls.caCertFile }}{{ if ne (default "yes" .Values.redis.authClients) "no" }} --cert /tls-certs/{{ .Values.tls.certFile }} --key /tls-certs/{{ .Values.tls.keyFile }}{{ end }} \
      {{- end }}
{{- end }}

{{- define "redis_liveness.sh" }}
    response=$(
      redis-cli \
      {{- include "redis-cli-options" . }}
        ping
    )
    echo "response=$response"
    case $response in
      PONG|LOADING*) ;;
      *) exit 1 ;;
    esac
    exit 0
{{- end }}

{{- define "redis_readiness.sh" }}
    response=$(
      redis-cli \
      {{- include "redis-cli-options" . }}
        ping
    )
    if [ "$response" != "PONG" ] ; then
      echo "ping=$response"
      exit 1
    fi
    exit 0
{{- end }}
