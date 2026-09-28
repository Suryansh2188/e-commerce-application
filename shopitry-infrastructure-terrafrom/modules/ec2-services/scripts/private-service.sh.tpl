#!/bin/bash

set -e

exec > >(tee /var/log/shopitry-setup.log | logger -t shopitry -s 2>/dev/console) 2>&1

echo "Starting ${service_name}"

# =========================================================
# System update
# =========================================================

apt-get update -y

apt-get install -y \
    curl \
    git \
    ca-certificates \
    build-essential


# =========================================================
# Node.js 20
# =========================================================

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt-get install -y nodejs

echo "Node:"
node --version

echo "NPM:"
npm --version


# =========================================================
# PM2
# =========================================================

npm install -g pm2

echo "PM2:"
pm2 --version


# =========================================================
# Application
# =========================================================

mkdir -p /var/www

if [ ! -d "/var/www/backend/.git" ]; then

    git clone \
        --branch ${git_branch} \
        ${git_repo} \
        /var/www/backend

else

    cd /var/www/backend

    git pull origin ${git_branch}

fi


# =========================================================
# Microservice
# =========================================================

cd /var/www/backend/${service_folder}

echo "Application directory:"
pwd


# =========================================================
# Install dependencies
# =========================================================

npm install


# =========================================================
# Environment file
# =========================================================

cat <<EOT > .env
PORT=${service_port}
EOT


# =========================================================
# Service-specific environment variables
# =========================================================

if [ "${service_name}" = "catalog-service" ]; then

cat <<EOT >> .env
MONGODB_URI=${catalog_mongodb_uri}
EOT

fi


if [ "${service_name}" = "cart-service" ]; then

cat <<EOT >> .env
MONGODB_URI=${cart_mongodb_uri}
EOT

fi


if [ "${service_name}" = "order-service" ]; then

cat <<EOT >> .env
MONGODB_URI=${order_mongodb_uri}
CART_SERVICE_URL=http://${cart_private_ip}:5002
PAYMENT_SERVICE_URL=${payment_api_url}
NOTIFICATION_SERVICE_URL=${notification_api_url}
EOT

fi


# =========================================================
# Show generated configuration
# =========================================================

echo "Generated environment configuration:"
cat .env


# =========================================================
# Start PM2
# =========================================================

pm2 delete "${service_name}" || true

pm2 start npm \
    --name "${service_name}" \
    -- start

pm2 save


# =========================================================
# PM2 startup
# =========================================================

pm2 startup systemd -u root --hp /root || true

pm2 save


# =========================================================
# Status
# =========================================================

echo "========================================"
echo "${service_name} started"
echo "Port: ${service_port}"
echo "========================================"

pm2 status