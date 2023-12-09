#!/usr/bin/env bash
set -e  # Stop on any error

# Define the project directory
PROJECT_DIR="/home/ubuntu/library_project"

# Navigate to the project directory
cd $PROJECT_DIR

# Create a virtual environment if it does not exist
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate the virtual environment
source venv/bin/activate

# Install dependencies from requirements.txt
pip install -r requirements.txt

# Ensure Gunicorn is installed
pip install gunicorn

# Run migrations and collect static files
python3 manage.py migrate
python3 manage.py collectstatic --noinput

# Start Gunicorn server (replace 'quote_project.wsgi:application' with your Django app's WSGI application)
#gunicorn quote_project.wsgi:application --bind 0.0.0.0:8000
gunicorn library_project.wsgi:application --bind 0.0.0.0:8000 --daemon
