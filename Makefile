name = Wasabi
cmd  = terraform

vars_file    = ./buckets.tfvars.json
deploy_file  = ./deploy.tfplan

profile = default
region = us-east-1

.PHONY: plan apply refresh fmt clean destroy

default:
	@$(cmd) init
	
plan:
	@$(cmd) plan \
		-out=$(deploy_file) \
		-var-file=$(vars_file) \
		-var="profile=$(profile)" \
		-var="region=$(region)"

destroy:
	@$(cmd) destroy \
		-var-file=$(vars_file) \
		-var="profile=$(profile)" \
		-var="region=$(region)"

apply:
	@$(cmd) apply "$(deploy_file)"

refresh:
	@$(cmd) refresh

fmt:
	@$(cmd) fmt -recursive

clean:
	@rm -rf .$(cmd) $(cmd).tfstate .$(cmd).lock.hcl *.tfplan
