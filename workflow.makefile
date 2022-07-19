# ========== #
#  Workflow  #
# ========== #
#
# Tasks without need for `terraform output`s environment vars

release:
	npx standard-version \
		--release-as minor \
		--packageFiles manifest.json \
		--bumpFiles manifest.json \
		--skip.commit \
		--skip.tag

init-dev:
	terraform init -backend-config=backends/dev.hcl -reconfigure

init-staging:
	terraform init -backend-config=backends/staging.hcl -reconfigure

plan-dev:
	terraform plan -var-file=environments/dev/dev.cluster.tfvars -out plan.tfplan

plan-staging:
	terraform plan -var-file=environments/staging/staging.cluster.tfvars -out plan.tfplan

refresh-dev:
	terraform refresh -var-file=environments/dev/dev.cluster.tfvars

refresh-staging:
	terraform refresh -var-file=environments/staging/staging.cluster.tfvars

destroy-dev:
	terraform destroy -var-file=environments/dev/dev.cluster.tfvars

destroy-staging:
	terraform destroy -var-file=environments/staging/staging.cluster.tfvars

apply:
	terraform apply plan.tfplan
