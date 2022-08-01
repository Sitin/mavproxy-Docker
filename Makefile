###########################################################
# Developer's Guide
###########################################################
#
# All tasks should be explicitly marked as .PHONY at the
# top of the section.
#
# We distinguish two types of tasks: private and public.
#
# "Public" tasks should be created with the description
# using ## comment format:
#
#   public-task: task-dependency ## Task description
#
# Private tasks should start with "_". There should be no
# description E.g.:
#
#   _private-task: task-dependency
#

###########################################################
# Setup
###########################################################

# Include .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

###########################################################
# Project directories
###########################################################

root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
volumes_dir := $(root_dir)/.volumes
state_dir := $(volumes_dir)/state
logs_dir := $(volumes_dir)/logs

###########################################################
# Config
###########################################################

dotenv_paths := "$(root_dir)"
docker_image := sitin/mavproxy:local
tag := $(shell git describe --tags --abbrev=0 2>/dev/null)
version := $(shell cat $(root_dir)/.VERSION)

###########################################################
# Help
###########################################################
.PHONY: help

help: ## Shows help
	@printf "\033[33m%s:\033[0m\n" 'Use: make <command> where <command> one of the following'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

###########################################################
# Initialization
###########################################################
.PHONY: init init-env reset-env

init: init-env ## Initializes project

init-env: ## Initializes .env files
	@echo "Creating .env files in $(dotenv_paths)..." && $(foreach dir, $(dotenv_paths), rsync -a -v --ignore-existing $(dir)/.env.template $(dir)/.env; )

reset-env: ## Resets .env files
	@echo "Deleting .env files in $(dotenv_paths)..." && $(foreach dir, $(dotenv_paths), rm -f $(dir)/.env; )

###########################################################
# Building
###########################################################
.PHONY: build

build: ## Build all services in Docker
	MAVPROXY_TAG="$(tag)" docker compose build

###########################################################
# Running
###########################################################
.PHONY: up down mavproxy

up: ## Start all services in Docker
	@docker compose run --rm mavproxy

down: ## Shuts down dockerized application and removes docker resources
	@docker compose down --remove-orphans

###########################################################
# Testing
###########################################################
.PHONY: test

test: ## Tests that MAVProxy can be built for all architectures
	@docker buildx create --use && \
	docker buildx build \
		--build-arg MAVPROXY_TAG="$(tag)" \
		--platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
		--tag "$(docker_image)"  \
		--file Dockerfile .

###########################################################
# Cleaning
###########################################################
.PHONY: clean clean-state clean-logs

clean: down clean-state clean-logs ## Cleans environment

clean-state: ## Cleans simulation state
	rm -rf $(state_dir)

clean-logs: ## Cleans simulation state
	rm -rf $(logs_dir)

kill-kill-kill: ## Stop all Docker containers
	@docker stop $(shell docker ps -q)
