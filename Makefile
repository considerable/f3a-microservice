.PHONY: setup security deploy-infra deploy-app test clean

# Setup development environment
setup:
	pip3 install pre-commit detect-secrets
	python3 -m pre_commit install
	python3 -m detect_secrets scan . > .secrets.baseline

# Run security scans
security:
	python3 -m pre_commit run --all-files
	python3 -m detect_secrets scan .

# Deploy infrastructure
deploy-infra:
	cd iac && terraform init && terraform apply -auto-approve

# Deploy application
deploy-app:
	cd k8s && ./deploy.sh

# Full deployment
deploy: deploy-infra deploy-app

# Test endpoints
test:
	@echo "Testing health endpoint..."
	@curl -s http://localhost:3000/health | jq
	@echo "Testing club API..."
	@curl -s http://localhost:3000/api/club | jq

# Clean up resources
clean:
	cd iac && terraform destroy -auto-approve
