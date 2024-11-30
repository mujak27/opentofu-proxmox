apply:
	tofu apply -var-file=secret.tfvars
plan:
	tofu plan -var-file=secret.tfvars