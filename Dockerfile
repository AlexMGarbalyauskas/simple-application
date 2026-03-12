FROM node:18-alpine

# Install nginx and openssl
RUN apk add --no-cache nginx openssl

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
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 443

CMD ["/start.sh"]
