#!/bin/sh
set -e

# Start Node app in background
cd /app && node ./bin/www &

# Wait for Node to be ready on port 3000
for i in $(seq 1 10); do
  nc -z 127.0.0.1 3000 && break
  sleep 1
done

# Start nginx in foreground
nginx -g "daemon off;"
