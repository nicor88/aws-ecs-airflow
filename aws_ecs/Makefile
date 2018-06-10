.EXPORT_ALL_VARIABLES:

STACK_NAME = airflow-ecs

default: validate

validate:
	aws cloudformation validate-template --template-body file://stack.yml
	@echo "Template valid"

check_aws_profile:
	@test -n "$(AWS_DEFAULT_PROFILE)"

create: check_aws_profile
	aws cloudformation create-stack --stack-name $$STACK_NAME --template-body file://stack.yml --capabilities CAPABILITY_IAM
	aws cloudformation wait stack-create-complete --stack-name $$STACK_NAME
	@echo "Template created"

update: check_aws_profile
	aws cloudformation update-stack --stack-name $$STACK_NAME --template-body file://stack.yml --capabilities CAPABILITY_IAM
	aws cloudformation wait stack-update-complete --stack-name $$STACK_NAME
	@echo "Template updated"

delete: check_aws_profile
	aws cloudformation delete-stack --stack-name $$STACK_NAME
	aws cloudformation wait stack-delete-complete --stack-name $$STACK_NAME
	@echo "Template deleted"

clean: check_aws_profile
	aws cloudformation delete-stack --stack-name $$STACK_NAME
	aws cloudformation wait stack-delete-complete --stack-name $$STACK_NAME
	@echo "Template deleted"
