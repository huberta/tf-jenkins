.PHONY: config update plan

config:
	@echo "Configuring remote backend"
	terraform remote config -backend=s3 \
    -backend-config="bucket=ngc-devops" \
    -backend-config="key=terraform-prod/ngc_us-west-2/terraform.tfstate" \
    -backend-config="region=us-east-1"

plan:
	@echo "You must run a 'make apply' in order to deploy this plan"
	terraform get --update
	terraform plan -var-file="./terraform.tfvars" -out terraform.tfplan

apply:
	terraform apply -var-file="./terraform.tfvars"

update:
	terraform get --update

destroy:
	terraform plan -destroy -var-file="./terraform.tfvars" -out terraform.tfplan
	terraform apply terraform.tfplan
