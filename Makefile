.PHONY: run_server run_otel clean

run_server:
	cd app && opentelemetry-instrument \
	--traces_exporter otlp \
	--exporter_otlp_endpoint http://localhost:4318 \
	--exporter_otlp_traces_endpoint http://localhost:4318/v1/traces \
	--exporter_otlp_protocol http/protobuf \
	--service_name flask-app \
	flask run --port=5555

run_otel:
	docker compose -f docker/docker-compose.yml up -d

clean:
	docker compose -f docker/docker-compose.yml down -v
