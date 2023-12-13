#!/bin/bash

# Function to truncate a log file to the last n lines
truncate_log() {
    local file=$1
    local lines=$2
    if [ -f "$file" ]; then
        # Create a temporary file
        local temp_file=$(mktemp)
        
        # Keep the last n lines
        sudo tail -n $lines "$file" > "$temp_file"
        
        # Replace the original file with the truncated version
        sudo mv "$temp_file" "$file"
    fi
}

# Truncate Traefik logs
truncate_log "/home/slayo/docker/traefik/logs/access.log" 1000
truncate_log "/home/slayo/docker/traefik/logs/traefik.log" 1000
