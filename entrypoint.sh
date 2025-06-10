#!/bin/bash
set -e

# Run Prisma migrations
echo "Running Prisma migrations..."
npx prisma migrate deploy

# Start Prisma Studio in the background
echo "Starting Prisma Studio..."
npx prisma studio &


# Keep the container running
wait