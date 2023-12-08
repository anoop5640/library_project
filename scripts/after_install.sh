#!/usr/bin/env bash

# Navigate to the application directory
cd /home/ubuntu/library_project/

# Activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Start Gunicorn with 3 worker processes
gunicorn --workers 3 library_project.wsgi:application --bind 0.0.0.0:8000 &

# Nginx configuration
cat <<EOF | sudo tee /etc/nginx/sites-available/library_project
server {
    listen 80;
    server_name ec2-3-252-97-29.eu-west-1.compute.amazonaws.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the site and restart Nginx
sudo ln -sf /etc/nginx/sites-available/library_project /etc/nginx/sites-enabled
sudo systemctl restart nginx
