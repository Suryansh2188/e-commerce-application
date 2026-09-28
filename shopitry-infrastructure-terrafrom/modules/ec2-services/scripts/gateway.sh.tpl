#!/bin/bash

set -e

exec > >(tee /var/log/shopitry-gateway-setup.log | logger -t shopitry-gateway -s 2>/dev/console) 2>&1

echo "Starting gateway setup"


# =========================================================
# System
# =========================================================

apt-get update -y

apt-get install -y \
    curl \
    git \
    nginx \
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
# Clone repository
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
# Gateway application
# =========================================================

cd /var/www/backend/${service_folder}

echo "Application directory:"
pwd

npm install


# =========================================================
# Gateway Environment
# =========================================================

cat <<EOT > .env
PORT=${service_port}

CATALOG_SERVICE_URL=http://${catalog_private_ip}:5001
CART_SERVICE_URL=http://${cart_private_ip}:5002
ORDER_SERVICE_URL=http://${order_private_ip}:5003

PAYMENT_SERVICE_URL=${payment_api_url}
NOTIFICATION_SERVICE_URL=${notification_api_url}
EOT

chmod 600 .env

echo "Gateway environment file created"


# =========================================================
# Start Gateway with PM2
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
# NGINX
# =========================================================

rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/sites-available/shopitry <<'NGINX'

server {

    listen 80;

    server_name ${domain_name};

    # Redirect HTTP to HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}


server {

    listen 443 ssl;
    server_name ${domain_name};

    # =====================================================
    # TLS certificate
    # =====================================================
    #
    # IMPORTANT:
    # You must configure your SSL certificate here.
    #
    # Example:
    #
    # ssl_certificate     /etc/letsencrypt/live/${domain_name}/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/${domain_name}/privkey.pem;
    #
    # =====================================================


    # =====================================================
    # Gateway Node.js application
    # =====================================================

    location / {

        proxy_pass http://127.0.0.1:${service_port};

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }


    # =====================================================
    # Catalog
    # =====================================================

    location /catalog/ {

        proxy_pass http://${catalog_private_ip}:5001/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }


    # =====================================================
    # Cart
    # =====================================================

    location /cart/ {

        proxy_pass http://${cart_private_ip}:5002/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }


    # =====================================================
    # Order
    # =====================================================

    location /order/ {

        proxy_pass http://${order_private_ip}:5003/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }


    # =====================================================
    # Payment Lambda / API Gateway
    # =====================================================

    location /payment/ {

        proxy_pass ${payment_api_url}/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }


    # =====================================================
    # Notification Lambda / API Gateway
    # =====================================================

    location /notification/ {

        proxy_pass ${notification_api_url}/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

NGINX


# =========================================================
# Enable NGINX site
# =========================================================

ln -sf /etc/nginx/sites-available/shopitry \
       /etc/nginx/sites-enabled/shopitry


# =========================================================
# Test NGINX
# =========================================================

nginx -t


# =========================================================
# Enable and restart NGINX
# =========================================================

systemctl enable nginx

systemctl restart nginx


# =========================================================
# Complete
# =========================================================

echo "========================================"
echo "Gateway setup completed"
echo "Service: ${service_name}"
echo "Port: ${service_port}"
echo "========================================"

pm2 status