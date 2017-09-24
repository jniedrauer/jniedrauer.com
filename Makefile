# vim: set noet

ENV := prod

help:
	@echo "Wrapper for terraform. Use \`make plan\` or \`make apply\`"

.terraform:
	terraform init ${ENV}

setup: .terraform
	terraform get ${ENV}

plan: setup
	terraform plan -var-file=${ENV}/${ENV}.tfvars -state=${ENV}/${ENV}.tfstate ${ENV}

apply:
	terraform apply -var-file=${ENV}/${ENV}.tfvars -state=${ENV}/${ENV}.tfstate ${ENV}

destroy:
	terraform destroy -var-file=${ENV}/${ENV}.tfvars -state=${ENV}/${ENV}.tfstate ${ENV}

.PHONY: help all setup plan apply destroy output
