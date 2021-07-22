#!/usr/bin/env bash

set -ef

conf="/usr/local/openresty/nginx/conf/conf.d"
ssl_cert="/certs/domain.crt"
vars='\$NGINX_LISTEN_PORT \$SSL_CONFIG \$HTTP_TO_HTTPS_REDIRECT \$DEFAULT_DOMAIN \$CORS_CONF \$CENTRIFUGO_ADDR'

if [ -f $ssl_cert ]; then
   NGINX_LISTEN_PORT="443 ssl"
   SSL_CONFIG="https_config.conf"
   HTTP_TO_HTTPS_REDIRECT="http_to_https_redirect.conf"
fi

export NGINX_LISTEN_PORT=${NGINX_LISTEN_PORT:-80} \
       HTTP_TO_HTTPS_REDIRECT=${HTTP_TO_HTTPS_REDIRECT:-empty.conf} \
       SSL_CONFIG=${SSL_CONFIG:-empty.conf} \
       DEFAULT_DOMAIN=${DEFAULT_DOMAIN:-_} \
       CENTRIFUGO_ADDR=${CENTRIFUGO_ADDR:-centrifugo} \
       CORS_CONF="empty.conf"


if [ -n "$USE_CORS_PROXY" ]; then
    export NGINX_LISTEN_PORT=${NGINX_LISTEN_PORT:-80} \
       HTTP_TO_HTTPS_REDIRECT=${HTTP_TO_HTTPS_REDIRECT:-empty.conf} \
       SSL_CONFIG=${SSL_CONFIG:-empty.conf} \
       DEFAULT_DOMAIN=${DEFAULT_DOMAIN:-_} \
       CENTRIFUGO_ADDR=${CENTRIFUGO_ADDR:-centrifugo} \
       CORS_CONF="cors_proxy.conf"
fi

envsubst "$vars" < "$conf/default.tpl" > "$conf/default.conf"

nginx -g 'daemon off;'
