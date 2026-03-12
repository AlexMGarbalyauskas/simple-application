#!/bin/bash
set -e

mkdir -p /etc/ssl/private /etc/ssl/certs

if [ ! -f /etc/ssl/certs/server.crt ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/server.key \
    -out /etc/ssl/certs/server.crt \
    -subj "/C=IE/ST=Dublin/L=Dublin/O=College/CN=simplapplication-ca.duckdns.org"
  echo "Self-signed certificate generated"
else
  echo "Certificate already exists, skipping generation"
fi
