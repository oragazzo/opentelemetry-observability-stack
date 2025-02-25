# OpenTelemetry Observability Example

This project demonstrates a complete observability stack using OpenTelemetry, showcasing how to collect, process, and visualize telemetry data (traces, metrics, and logs) from a simple Flask application.

## Architecture

The project consists of the following components:

- **Sample Flask Application**: A simple REST API with user management endpoints
- **OpenTelemetry Collector**: Receives, processes, and exports telemetry data
- **ClickHouse**: High-performance columnar database for storing telemetry data
- **Prometheus**: Time series database for metrics storage and querying
- **Grafana**: Visualization and dashboarding platform

```
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────┐
│                 │     │                     │     │                 │
│  Flask App      │────▶│  OTel Collector     │────▶│  ClickHouse     │
│  (Instrumented) │     │                     │     │                 │
└─────────────────┘     └─────────────────────┘     └─────────────────┘
                                  │                          ▲
                                  │                          │
                                  ▼                          │
                         ┌─────────────────┐                 │
                         │                 │                 │
                         │  Prometheus     │                 │
                         │                 │                 │
                         └─────────────────┘                 │
                                  │                          │
                                  │                          │
                                  ▼                          │
                         ┌─────────────────┐                 │
                         │                 │                 │
                         │  Grafana        │─────────────────┘
                         │                 │
                         └─────────────────┘
```

## Prerequisites

- Docker and Docker Compose
- Python 3.8+ (for local development)
- Make (optional, for using the Makefile commands)

## Getting Started

### 1. Start the Observability Stack

Launch the OpenTelemetry Collector, ClickHouse, Prometheus, and Grafana:

```bash
make run_otel
# or
docker compose up -d
```

### 2. Run the Flask Application

Start the Flask application with OpenTelemetry instrumentation:

```bash
make run_server
# or
cd app && ./start_app.sh
```

The application will be available at http://localhost:5555

## Available Endpoints

- `GET /`: Simple hello world endpoint
- `GET /error`: Endpoint that generates an error (for testing error tracking)
- `GET /api/users/<username>`: Get user information
- `POST /api/users/<username>`: Create a new user
  - Request body: `{"email": "user@example.com"}`

## Accessing the Dashboards

- **Grafana**: http://localhost:3000 (username: admin, password: admin)
- **Prometheus**: http://localhost:9090
- **ClickHouse**: http://localhost:8123 (username: default, password: clickhouse)

## Project Structure

```
.
├── app/                    # Flask application
│   ├── app.py              # Main application code
│   ├── database.py         # Database operations
│   ├── example.py          # Example code
│   ├── start_app.sh        # Script to start the app with OTel instrumentation
│   └── users.db            # SQLite database
├── backups/                # ClickHouse backups directory
├── clickhouse/             # ClickHouse data directory
├── backup_disk.xml         # ClickHouse backup configuration
├── docker-compose.yml      # Docker Compose configuration
├── grafana-datasources.yml # Grafana datasource configuration
├── init-db.sql             # ClickHouse initialization SQL
├── Makefile                # Convenience commands
├── otel-collector-config.yml # OpenTelemetry Collector configuration
├── prometheus.yml          # Prometheus configuration
└── tempo.yml               # Tempo configuration
```

## OpenTelemetry Configuration

The OpenTelemetry Collector is configured to:

1. Receive telemetry data via OTLP (HTTP and gRPC) and FluentForward protocols
2. Process the data using batching and memory limiting
3. Export the data to:
   - ClickHouse for traces and logs
   - Prometheus for metrics
   - Debug exporter for troubleshooting

## Development

### Adding OpenTelemetry to Your Own Application

To instrument your Python application with OpenTelemetry:

1. Install the required packages:
   ```bash
   pip install opentelemetry-api opentelemetry-sdk opentelemetry-instrumentation
   ```

2. Use the auto-instrumentation command:
   ```bash
   opentelemetry-instrument \
     --traces_exporter otlp \
     --exporter_otlp_endpoint http://localhost:4318 \
     --exporter_otlp_protocol http/protobuf \
     --service_name your-service-name \
     python your_app.py
   ```

## Troubleshooting

- If you encounter issues with the OpenTelemetry Collector, check the logs:
  ```bash
  docker compose logs otel-collector
  ```

- To verify ClickHouse is receiving data:
  ```bash
  curl -u default:clickhouse "http://localhost:8123/ping"
  ```

## License

This project is open source and available under the [MIT License](LICENSE). 