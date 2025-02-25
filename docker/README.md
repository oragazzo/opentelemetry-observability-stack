# Docker Configuration

This directory contains all Docker-related configuration files for the OpenTelemetry observability stack.

## Directory Structure

- `docker-compose.yml`: Main Docker Compose configuration file
- `config/`: Configuration files for each service
  - `clickhouse/`: ClickHouse database configuration
    - `backup_disk.xml`: ClickHouse backup configuration
    - `init-db.sql`: Database initialization script
  - `grafana/`: Grafana configuration
    - `grafana-datasources.yml`: Datasource configuration
  - `otel/`: OpenTelemetry Collector configuration
    - `otel-collector-config.yml`: Collector configuration
  - `prometheus/`: Prometheus configuration
    - `prometheus.yml`: Prometheus configuration

## Usage

The main docker-compose.yml file in the project root extends this configuration, so you can run:

```bash
# From project root
docker compose up -d
```

Or you can run directly from this directory:

```bash
# From docker directory
docker compose up -d
```

## Service Configuration

### OpenTelemetry Collector

The OpenTelemetry Collector is configured to receive telemetry data via OTLP (HTTP and gRPC) and FluentForward protocols, and export it to ClickHouse and Prometheus.

### ClickHouse

ClickHouse is used to store traces. The initialization script creates the necessary tables.

### Prometheus

Prometheus is used to store metrics data.

### Grafana

Grafana is configured with datasources for ClickHouse and Prometheus to visualize the telemetry data. 