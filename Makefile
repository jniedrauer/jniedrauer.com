# vim: set noet

ENV := prod

VENV=venv
PYTHON=python3
PIP=$(VENV)/bin/pip

setup: tfsetup venv

$(PIP):
	$(PYTHON) -m venv $(VENV)

venv: $(VENV)/bin/activate

$(VENV)/bin/activate: requirements.txt
	test -d $(VENV) || $(PYTHON) -m venv $(VENV)
	$(PIP) install -Ur requirements.txt

.terraform:
	terraform init ${ENV}

tfsetup: .terraform
	terraform get ${ENV}

plan: tfsetup
	terraform plan -state=${ENV}/${ENV}.tfstate ${ENV}

apply:
	terraform apply -state=${ENV}/${ENV}.tfstate ${ENV}

destroy:
	terraform destroy -state=${ENV}/${ENV}.tfstate ${ENV}

help:
	@echo "No target specified will create a virtualenv and init terraform."
	@echo "Use \`make plan\` or \`make apply\` for terraform deployment."

.PHONY: help setup tfsetup plan apply destroy
