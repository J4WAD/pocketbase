#!/bin/sh
# Check if admin exists by trying to list admins (fails if none exist)
if ! /usr/local/bin/pocketbase admin list --dir=/pb_data; then
  echo "No admin found, creating one..."
  /usr/local/bin/pocketbase admin create admin@example.com password123456789 --dir=/pb_data
fi
# Start the server
/usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir=/pb_data