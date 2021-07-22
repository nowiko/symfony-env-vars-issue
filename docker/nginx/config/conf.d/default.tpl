include ${HTTP_TO_HTTPS_REDIRECT};

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen ${NGINX_LISTEN_PORT};

    server_name ${DEFAULT_DOMAIN};

    include ${SSL_CONFIG};

    root /srv;
    index index.html;
    aio threads;
    directio 16M;
    output_buffers 2 1M;

    sendfile on;
    sendfile_max_chunk 512k;

    gzip             on;
    gzip_comp_level  2;
    gzip_min_length  1000;
    gzip_proxied     expired no-cache no-store private auth;
    gzip_types       text/plain application/x-javascript application/javascript text/xml text/css application/xml;

    add_header "Pragma" "no-cache";
    add_header X-Frame-Options "DENY";

    include ${CORS_CONF};

    if ($request_uri ~ "^[^?]*?//") {
        rewrite "^" $scheme://$host$uri permanent;
    }

    location /demo/ {
        index index.html;
    }

    location ~* ^/(_profiler|_wdt|api)/.* {
        fastcgi_pass php:9000;

        fastcgi_buffer_size 1024k;
        fastcgi_buffers 8 1024k;
        fastcgi_busy_buffers_size 1024k;

        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME    /app/public/index.php;
        fastcgi_param  SCRIPT_NAME        index.php;
    }

    location /_apidoc {
        add_header Content-Type text/html;
        alias /srv/api_documentation.html;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
