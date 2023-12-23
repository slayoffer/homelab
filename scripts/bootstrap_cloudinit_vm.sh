#!/bin/bash

# Install qemu-guest-agent
DEBIAN_FRONTEND=noninteractive sudo apt install qemu-guest-agent -y

# Download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz

# Extract node_exporter
tar xvf node_exporter-1.7.0.linux-amd64.tar.gz

# Copy node_exporter binary to /usr/local/bin
sudo cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin

# Remove the extracted directory and tar.gz file
rm -rf node_exporter-1.7.0.linux-amd64 node_exporter-1.7.0.linux-amd64.tar.gz

# Add node_exporter user
sudo useradd --no-create-home --shell /bin/false node_exporter

# Change ownership of the node_exporter binary
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create node_exporter service file
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start node_exporter service
sudo systemctl daemon-reload && sudo systemctl enable node_exporter && sudo systemctl start node_exporter

# Create or update 99-disable-network-config.cfg
echo "network: {config: disabled}" | sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

# Function to update 50-cloud-init.yaml with nameservers
update_netplan() {
    # Check if nameservers entry exists under eth0
    if ! grep -q "nameservers:" /etc/netplan/50-cloud-init.yaml; then
        echo "Appending nameservers entry under dhcp4 of eth0 in /etc/netplan/50-cloud-init.yaml"
        sudo sed -i '/dhcp4: true/a \            nameservers:\n                addresses: [192.168.3.68, 1.1.1.1]' /etc/netplan/50-cloud-init.yaml
    else
        echo "Nameservers entry already exists under dhcp4 of eth0 in /etc/netplan/50-cloud-init.yaml. Please update it manually if needed."
    fi
}

# Update 50-cloud-init.yaml
sudo bash -c "$(declare -f update_netplan); update_netplan"

# Apply netplan configuration
sudo netplan apply
