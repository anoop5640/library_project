#!/usr/bin/env bash

# Define your Django project name
DJANGO_PROJECT_NAME='library_project'  # replace with your Django project name

# Define the domain or public IP of your server
SERVER_DOMAIN_OR_IP='3.252.97.29'  # replace with your domain or public IP

# Navigate to the application directory
cd /home/ubuntu/library_project/

# Activate the virtual environment
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Start Gunicorn with 3 worker processes
gunicorn --workers 3 $DJANGO_PROJECT_NAME.wsgi:application --bind 0.0.0.0:8000 &

# Wait for a few seconds to ensure Gunicorn starts
sleep 5

# Create Nginx server block configuration
sudo bash -c "cat > /etc/nginx/sites-available/library_project" << EOF
server {
    listen 80;
    server_name $SERVER_DOMAIN_OR_IP;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the Nginx server block by creating a symbolic link
sudo ln -sf /etc/nginx/sites-available/library_project /etc/nginx/sites-enabled/library_project

# Restart Nginx to apply the changes
sudo systemctl restart nginx
