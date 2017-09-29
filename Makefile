# vim: set noet

ENV := prod
TAG := $(shell git rev-parse --short HEAD)
EMAIL = jniedrauer.com
IMAGE_NAME = jniedrauer.com
REPO_NAME = jniedrauer
AWS_PROFILE = jniedrauer.com
REGION = us-east-1
REPO := $(shell AWS_PROFILE=${AWS_PROFILE} \
	aws ecr describe-repositories --region=${REGION} \
	--repository-names=$(REPO_NAME) \
	--output=text --query 'repositories[].repositoryUri')

VENV = venv
PYTHON = python3
PIP = $(VENV)/bin/pip
DOCKER = docker
TERRAFORM = terraform

setup: tfsetup venv

########
# venv #
########

$(PIP):
	$(PYTHON) -m venv $(VENV)

venv: $(VENV)/bin/activate

$(VENV)/bin/activate: requirements.txt
	test -d $(VENV) || $(PYTHON) -m venv $(VENV)
	$(PIP) install -Ur requirements.txt

##########
# Docker #
##########

build:
	$(DOCKER) build -t ${REPO_NAME}/${IMAGE_NAME}:${TAG} .

deploy:
	AWS_PROFILE=${AWS_PROFILE} \
		aws ecr get-authorization-token --region=${REGION} \
		--output=text --query 'authorizationData[].authorizationToken' \
	| base64 -d | cut -d: -f2 \
	| $(DOCKER) login -u AWS ${REPO} --password-stdin
	$(DOCKER) tag ${REPO_NAME}/${IMAGE_NAME}:${TAG} ${REPO}/${IMAGE_NAME}:${TAG}
	$(DOCKER) push ${REPO}

#############
# terraform #
#############

.terraform:
	$(TERRAFORM) init ${ENV}

tfsetup: .terraform
	$(TERRAFORM) get ${ENV}

refresh:
	$(TERRAFORM) refresh ${ENV}

plan: tfsetup
	$(TERRAFORM) plan ${ENV}

apply:
	$(TERRAFORM) apply ${ENV}

destroy:
	$(TERRAFORM) destroy ${ENV}

help:
	@echo "No target specified will create a virtualenv and init terraform."
	@echo "Use \`make plan\` or \`make apply\` for terraform deployment."

.PHONY: help setup build deploy tfsetup plan apply destroy
