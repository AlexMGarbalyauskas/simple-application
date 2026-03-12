FROM node:18-alpine

RUN apk add --no-cache nginx openssl

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Build-time self-signed cert
RUN mkdir -p /etc/ssl/private /run/nginx && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/ssl/private/server.key \
      -out /etc/ssl/certs/server.crt \
      -subj "/C=IE/ST=Dublin/L=Dublin/O=College/CN=simplapplication"

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

# Start node on 8080, then nginx
CMD sh -c "node /app/bin/www & sleep 8 && nginx -g 'daemon off;'"
