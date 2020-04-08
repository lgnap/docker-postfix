
help:           ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

build: ## Build image through docker-compose
	docker-compose build

run-ps: ## Run postfix & opendkim service
	docker-compose up postfix odkim

run-od: ## Run opendkim service
	docker-compose up odkim

run-swaks: ## Run swaks (test)
	docker-compose up swaks
