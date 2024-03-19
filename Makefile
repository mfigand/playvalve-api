#!make
.SILENT :

## Welcome to the Developer console!
##
##      usage: make <command> [service=<service_name>]
##
##      possible service_name values:
##          api, db, redis
##
##
##
## Available commands:
##
service?='api'
file?=''

# Include common Make tasks
root_dir:=$(shell pwd)

help: ## This help dialog.
	    @IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]}` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done
.PHONY: help


install: ## Installs all dependencies (docker for mac should be preinstalled)
	docker-compose build
	make init
	make start
	make stop
.PHONY: install

init: ## Init app
	docker-compose run --rm api bundle exec rails db:environment:set RAILS_ENV=development
	docker-compose run --rm -e RAILS_ENV=development api bundle exec rails db:create db:migrate
	bundle
.PHONY: init

start: ## Starts the application
	docker-compose up -d
.PHONY: start

stop: ## Stops the application
	docker-compose stop
.PHONY: stop

restart: ## Restarts the application
restart: stop start
.PHONY: restart

status: ## Status for the services (alias to docker-compose ps)
	docker-compose ps
.PHONY: status

bash: ## Initializes a bash
	docker-compose run --rm api bundle exec bash
.PHONY: bash

debug: ## Attaches to debug console for app (RoR). To exit use escape sequence (Ctrl P + Ctrl Q)
	docker attach playvalve_api-api-1
.PHONY: debug

lint: ## Run linter for the file passed as parameter or the entire suite if none passed. Syntax: make lint file=<path/to/file.rb>
	docker-compose run --rm api bundle exec rubocop $$file

test: ## Run tests for the file passed as parameter or the entire suite if none passed. Syntax: make test file=<path/to/test/file.rb>
	docker-compose run --rm api bundle exec rails db:environment:set RAILS_ENV=test
	docker-compose run --rm api bundle exec rails db:create db:migrate RAILS_ENV=test
	docker-compose run --rm -e RAILS_ENV=test api bundle exec rspec $$file
.PHONY: test


## -------
## Utils
## -------

logs: ## View logs
	docker-compose logs -f ${service}
.PHONY: logs

bundle: ## Bundle install
	docker-compose run --rm api bundle install
.PHONY: bundle

console: ## Opens a rails console in `development` environment
	docker-compose run api bundle exec rails c
.PHONY: console

seed: ## Seed the database
	docker-compose run api bundle exec rails db:seed
.PHONY: seed

db-migrate: ## Update db schema. Execute it when getting `PendingMigrationError`
	docker-compose run --rm api bundle exec rails db:create db:migrate RAILS_ENV=development

db-reset: ## Reset db schema. Execute it when you want to reset the database
	docker-compose run --rm api bundle exec rails db:reset RAILS_ENV=development

