#!/bin/bash

# OpenTelemetry Example Setup Script
# This script helps set up the OpenTelemetry example project

set -e

echo "Setting up OpenTelemetry Example project..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! docker compose version &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install -r ./app/requirements.txt

# Start the observability stack
echo "Starting the observability stack..."
make run_otel

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 10

echo "Setup complete! You can now run the application with:"
echo "  make run_server"
echo ""
echo "Access the dashboards at:"
echo "  Grafana: http://localhost:3000 (username: admin, password: admin)"
echo "  Prometheus: http://localhost:9090"
echo "  ClickHouse: http://localhost:8123 (username: default, password: clickhouse)" 