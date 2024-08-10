#!/bin/bash
sudo apt-get install -y build-essential docker.io docker-compose
echo "Starting setup and proof process..."

if [ ! -f "loader.sh" ]; then
    echo "Showing HCA logo..."
    wget -O loader.sh https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/loader.sh
    chmod +x loader.sh
else
    echo "loader.sh from HCA already exists. Skipping download."
fi

./loader.sh

echo "Creating new project 'fibonacci'..."
cargo prove new fibonacci
cd fibonacci || { echo "Failed to change directory to 'fibonacci'"; exit 1; }

echo "Executing Proof..."
if [ -d "script" ]; then
    cd script || { echo "Failed to change directory to 'script'"; exit 1; }
    
    echo "Running proof execution..."
    RUST_LOG=info cargo run --release -- --execute
    echo "Proof execution completed successfully."
    
    echo "Generating Proof..."
    RUST_LOG=info cargo run --release -- --prove
    echo "Proof generated and verified successfully."
else
    echo "Directory 'script' not found. Ensure the project was set up correctly."
    exit 1
fi

echo "Process completed successfully."
