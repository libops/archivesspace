.PHONY: build deps init up down rollout test lint

deps:
	docker compose pull --ignore-buildable

build: deps
	@echo "No custom image to build; official images are pulled by deps."

init:
	./scripts/init.sh

up: init
	docker compose up --remove-orphans -d

down:
	docker compose down

rollout:
	./scripts/rollout.sh

test:
	./scripts/test.sh

lint:
	./scripts/lint.sh
