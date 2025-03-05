.PHONY: run_server run_otel clean

run_server:
	cd app && opentelemetry-instrument \
	--traces_exporter otlp \
	--logs_exporter otlp \
	--metrics_exporter otlp \
	--exporter_otlp_endpoint http://localhost:4318 \
	--exporter_otlp_traces_endpoint http://localhost:4318/v1/traces \
	--exporter_otlp_logs_endpoint http://localhost:4318/v1/logs \
	--exporter_otlp_metrics_endpoint http://localhost:4318/v1/metrics \
	--exporter_otlp_protocol http/protobuf \
	--service_name flask-app \
	flask run --port=5555

run_otel:
	docker compose -f docker/docker-compose.yml up -d

clean:
	docker compose -f docker/docker-compose.yml down -v

backup:
	docker exec -it clickhouse clickhouse-client --query "BACKUP TABLE otel.otel_traces TO Disk('backups', 'otel_traces.zip')"

restore:
	docker exec -it clickhouse clickhouse-client --query "RESTORE TABLE otel.otel_traces FROM Disk('backups', 'otel_traces.zip')"
