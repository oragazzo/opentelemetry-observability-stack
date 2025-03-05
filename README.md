# OpenTelemetry Observability Example

This project demonstrates a complete observability stack using OpenTelemetry, showcasing how to collect, process, and visualize telemetry data (traces, metrics, and logs) from a simple Flask application.

## Architecture

The project consists of the following components:

- **Sample Flask Application**: A simple REST API with user management endpoints
- **OpenTelemetry Collector**: Receives, processes, and exports telemetry data
- **ClickHouse**: High-performance columnar database for storing traces and logs
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
docker compose -f docker/docker-compose.yml up -d
```

### 2. Run the Flask Application

Start the Flask application with OpenTelemetry instrumentation:

```bash
make run_server
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
- **OTel Collector Health**: http://localhost:13133/healthz

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
├── docker/                 # Docker configuration
│   ├── config/             # Service configurations
│   │   ├── clickhouse/     # ClickHouse configuration
│   │   ├── grafana/        # Grafana configuration
│   │   ├── otel/           # OpenTelemetry configuration
│   │   └── prometheus/     # Prometheus configuration
│   ├── docker-compose.yml  # Main Docker Compose file
│   └── README.md           # Docker setup documentation
├── docker-compose.yml      # Root Docker Compose wrapper
├── Makefile                # Convenience commands
└── .gitignore              # Git ignore file
```

## OpenTelemetry Configuration

The OpenTelemetry Collector is configured with the following components:

### Receivers
- OTLP (gRPC) on port 4317
- OTLP (HTTP) on port 4318

### Exporters
- ClickHouse: Stores traces and logs with 12-hour TTL
- Prometheus: Exposes metrics on port 8889
- Debug: Detailed logging for troubleshooting

### Processors
- Batch: 5s timeout, 100k batch size
- Memory Limiter: 1800MiB limit, 500MiB spike limit
- Resource Detection: System information
- Resource: Service name attribution

### Extensions
- Health Check: Available on port 13133
- pprof: For profiling
- zpages: For debugging

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

## Makefile Commands

- `make run_server`: Start the Flask application with OpenTelemetry instrumentation
- `make run_otel`: Start the observability stack (OpenTelemetry Collector, ClickHouse, Prometheus, Grafana)
- `make clean`: Stop and remove all containers and volumes
- `make backup`: Create a backup of the ClickHouse traces table to the backups disk
- `make restore`: Restore the ClickHouse traces table from a backup file on the backups disk

## Troubleshooting

### OpenTelemetry Collector
- Check collector health: `curl http://localhost:13133/healthz`
- View collector logs: `docker compose logs otel-collector`
- Access debug pages: http://localhost:13133/debug/tracez

### ClickHouse
- Verify connection: `curl -u default:clickhouse "http://localhost:8123/ping"`
- Check data ingestion: `curl -u default:clickhouse "http://localhost:8123/query" --data "SELECT count() FROM otel.otel_traces"`

### Prometheus
- Access metrics: http://localhost:8889/metrics
- Check targets: http://localhost:9090/targets

### Grafana
- Verify data sources: http://localhost:3000/datasources
- Check dashboard loading: http://localhost:3000/dashboards

## License

This project is open source and available under the [MIT License](LICENSE). 