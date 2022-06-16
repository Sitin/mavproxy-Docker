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
docker_image := sitin/mavproxy
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
	docker compose build

###########################################################
# Releasing
###########################################################
.PHONY: release publish inspect tag docker-login push

release: build publish ## Build and releases Docker images

publish: inspect tag docker-login push ## Publishes Docker prebuilt image

inspect: ## Inspect Docker image
	@echo Image size: $(shell docker image inspect $(docker_image):local --format='{{.Size}}')
	@echo Version: $(version)

tag: ## Tag Docker image
	@docker tag $(docker_image):local $(docker_image):latest
	@docker tag $(docker_image):local $(docker_image):$(version)

push: ## Push to Docker registry
	@docker push $(docker_image):$(version)
	@docker push $(docker_image):latest

docker-login: ## Login to Docker registry
	@echo $(DOCKER_HUB_ACCESS_TOKEN) | docker login --username sitin --password-stdin

###########################################################
# Running
###########################################################
.PHONY: up down mavproxy

up: ## Start all services in Docker
	@docker compose run --rm mavproxy

down: ## Shuts down dockerized application and removes docker resources
	@docker compose down --remove-orphans

###########################################################
# Cleaning
###########################################################
.PHONY: clean clean-state clean-logs

clean: down clean-state clean-logs ## Cleans environment

clean-state: ## Cleans simulation state
	rm -rf $(state_dir)

clean-logs: ## Cleans simulation state
	rm -rf $(logs_dir)
