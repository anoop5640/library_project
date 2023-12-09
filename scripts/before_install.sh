 #!/bin/bash

# Define the project directory
PROJECT_DIR="/home/ubuntu/library_project"

# Navigate to the project directory
cd $PROJECT_DIR

# If the virtual environment directory exists, remove it
if [ -d "venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf venv
fi

# Continue with any other pre-installation cleanup steps..