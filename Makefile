format:
	terraform fmt -recursive

deploy-cloudfront-dev:
	@echo "************************** cloudfront started *****************************"
	cd "development/cloudfront" && terraform init && terraform apply 
	@echo "************************** cloudfront completed *****************************"

destroy-cloudfront-dev:
	@echo "************************** cloudfront started *****************************"
	cd "development/cloudfront" && terraform destroy
	@echo "************************** cloudfront completed *****************************"

deploy-ec2-dev:
	@echo "************************** ec2 started *****************************"
	cd "development/ec2" && terraform init && terraform apply 
	@echo "************************** ec2 completed *****************************"

destroy-ec2-dev:
	@echo "************************** ec2 started *****************************"
	cd "development/ec2" && terraform destroy
	@echo "************************** ec2 completed *****************************"

deploy-ecs-dev:
	@echo "************************** ecs started *****************************"
	cd "development/ecs" && terraform init && terraform apply 
	@echo "************************** ecs completed *****************************"

destroy-ecs-dev:
	@echo "************************** ecs started *****************************"
	cd "development/ecs" && terraform destroy
	@echo "************************** ecs completed *****************************"

deploy-rds-dev:
	@echo "************************** rds started *****************************"
	cd "development/rds" && terraform init && terraform apply 
	@echo "************************** rds completed *****************************"

destroy-rds-dev:
	@echo "************************** rds started *****************************"
	cd "development/rds" && terraform destroy
	@echo "************************** rds completed *****************************"

deploy-dev-stack: format deploy-cloudfront-dev deploy-ec2-dev 
destroy-dev-stack: format destroy-cloudfront-dev destroy-ec2-dev destroy-rds-dev

# ************************************************************************************


deploy-cloudfront-stg:
	@echo "************************** cloudfront started *****************************"
	cd "staging/cloudfront" && terraform init && terraform apply
	@echo "************************** cloudfront completed *****************************"

destroy-cloudfront-stg:
	@echo "************************** cloudfront started *****************************"
	cd "development/cloudfront" && terraform destroy
	@echo "************************** cloudfront completed *****************************"

deploy-ec2-stg:
	@echo "************************** ec2 started *****************************"
	cd "staging/lambda" && terraform init && terraform apply
	@echo "************************** ec2 completed *****************************"

destroy-ec2-stg:
	@echo "************************** ec2 started *****************************"
	cd "development/cloudfront" && terraform destroy
	@echo "************************** ec2 completed *****************************"

deploy-rds-stg:
	@echo "************************** rds started *****************************"
	cd "staging/rds" && terraform init && terraform apply
	@echo "************************** rds completed *****************************"

destroy-rds-stg:
	@echo "************************** rds started *****************************"
	cd "development/cloudfront" && terraform destroy
	@echo "************************** rds completed *****************************"

deploy-stg-stack: format deploy-cloudfront-stg deploy-ec2-stg deploy-rds-stg
destroy-stg-stack: format destroy-cloudfront-stg destroy-ec2-stg destroy-rds-stg

# ************************************************************************************


deploy-cloudfront-prod:
	@echo "************************** cloudfront started *****************************"
	cd "production/cloudfront" && terraform init && terraform apply
	@echo "************************** cloudfront completed *****************************"

destroy-cloudfront-prod:
	@echo "************************** cloudfront started *****************************"
	cd "production/cloudfront" && terraform init && terraform apply
	@echo "************************** cloudfront completed *****************************"

deploy-ec2-prod:
	@echo "************************** ec2 started *****************************"
	cd "production/lambda" && terraform init && terraform apply
	@echo "************************** ec2 completed *****************************"

destroy-ec2-prod:
	@echo "************************** ec2 started *****************************"
	cd "production/lambda" && terraform init && terraform apply
	@echo "************************** ec2 completed *****************************"

deploy-rds-prod:
	@echo "************************** rds started *****************************"
	cd "staging/rds" && terraform init && terraform apply
	@echo "************************** rds completed *****************************"

destroy-rds-prod:
	@echo "************************** rds started *****************************"
	cd "staging/rds" && terraform init && terraform apply
	@echo "************************** rds completed *****************************"

deploy-prod-stack: format deploy-cloudfront-prod deploy-lambda-prod deploy-rds-prod
destroy-prod-stack: format destroy-cloudfront-prod destroy-lambda-prod destroy-rds-prod

# ************************************************************************************
