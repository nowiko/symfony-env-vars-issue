FROM openresty/openresty:alpine

RUN apk update && apk add gettext

COPY config /usr/local/openresty/nginx/conf/
COPY web /srv/
COPY boot.sh /usr/local/bin/boot_nginx

EXPOSE 80
EXPOSE 443
EXPOSE 9145

CMD ["sh", "/usr/local/bin/boot_nginx"]
