#!/bin/sh
set -e

# Start Node app in background
node /app/app.js &

# Start nginx in foreground
nginx -g "daemon off;"
