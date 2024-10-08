#!/bin/bash

# Variables
FILENAME=xmrig-6.22.0
URL="https://github.com/xmrig/xmrig/releases/download/v6.22.0/xmrig-6.22.0-focal-x64.tar.gz"
SERVICE_NAME="xmrig"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# Download file using wget
echo "Downloading $URL..."
wget -O $FILENAME $URL
if [ $? -ne 0 ]; then
  echo "Failed to download $URL"
  exit 1
fi

#unzip
tar -xzf ./xmrig-6.22.0

# Make the file executable
chmod +x $FILENAME

# Write systemd service file
echo "Writing systemd service file..."
cat <<EOL > $SERVICE_FILE
[Unit]
Description=Xmrig miner
After=network.target

[Service]
# The executable and its arguments
ExecStart=/home/$3/xmrig-6.22.0/xmrig -o $1 -a rx -k -u $2 -p x pause --thread=$4
# Restart on failure
Restart=on-failure
# Set the user and group under which the service will run
User=$3

# Working directory for the service
WorkingDirectory=/home/$3/xmrig-6.22.0

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd manager configuration
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Enable and start the service
echo "Enabling and starting the service..."
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME

echo "Service $SERVICE_NAME started successfully."
