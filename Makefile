all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build        - build the sonarqube image"
	@echo "   2. make quickstart   - start sonarqube"
	@echo "   3. make stop         - stop sonarqube"
	@echo "   4. make logs         - view logs"
	@echo "   5. make purge        - stop and remove the container"
	@echo "   6. make port         - view the exposed port"

build:
	@docker build --tag=${USER}/sonarqube .

quickstart:
	@echo "Starting sonarqube..."
	@fig up -d
	@echo "Please be patient. This could take a while..."
	@echo "Type 'make port' to view the exposed port"
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping sonarqube..."
	@fig stop

logs:
	@fig logs

purge: stop
	@echo "Removing stopped container..."
	@fig rm

port:
	@echo "Sonarqube will be available at http://$(shell sleep 3; docker port dockersonarqube_sonarqube_1 9000)"
