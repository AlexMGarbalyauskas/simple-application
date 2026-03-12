FROM node:18-alpine

# Install nginx, openssl and netcat
RUN apk add --no-cache nginx openssl netcat-openbsd

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Generate self-signed SSL certificate at build time
RUN mkdir -p /etc/ssl/private /run/nginx && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/ssl/private/server.key \
      -out /etc/ssl/certs/server.crt \
      -subj "/C=IE/ST=Dublin/L=Dublin/O=College/CN=simplapplication-ca.duckdns.org"

COPY nginx.conf /etc/nginx/nginx.conf

# Simple start script: start node, wait 5s, then start nginx
RUN printf '#!/bin/sh\nnode /app/bin/www &\necho "Node started, waiting 5s..."\nsleep 5\necho "Starting nginx..."\nnginx -g "daemon off;"\n' > /start.sh && chmod +x /start.sh

EXPOSE 80 443

CMD ["/start.sh"]
