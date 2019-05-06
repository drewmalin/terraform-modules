APP=example-app

AWS_ACCOUNT=$(shell aws sts get-caller-identity --output text --query 'Account')
AWS_REGION?=us-west-2
NAMESPACE=$(subst .,/-,${USER})

PORT=8080

GOCMD=go
DOCKERCMD=docker
AWSCMD=aws --region $(AWS_REGION)
TERRAFORMCMD=terraform

GOBUILD=$(GOCMD) build
GOFMT=$(GOCMD) fmt

SERVICE_DIR=cmd/service
TERRAFORM_DIR=terraform

BUILD_DIR=bin
BUILD_TAG=$(APP)-$(NAMESPACE)

deployRemote: compile buildDocker pushDockerRemote

deployLocal: compile buildDocker runDockerLocal

compile:
	env GOOS=linux $(GOBUILD) -o $(BUILD_DIR)/$(APP) -ldflags "-s -d -w" -tags netgo -installsuffix netgo -v ./$(SERVICE_DIR)

buildDocker:
	$(DOCKERCMD) build -t $(BUILD_TAG) .

applyTerraform:
	$(TERRAFORMCMD) init $(TERRAFORM_DIR)
	$(TERRAFORMCMD) apply -var="namespace=$(APP)-$(NAMESPACE)" -var="service_port=$(PORT)" $(TERRAFORM_DIR)

destroyTerraform:
	$(TERRAFORMCMD) destroy -var="namespace=$(APP)-$(NAMESPACE)" -var="service_port=$(PORT)" $(TERRAFORM_DIR)

pushDockerRemote:
	$(eval dockerLogin=$(shell ${AWSCMD} ecr get-login --no-include-email))
	${dockerLogin}

	$(eval awsAccount=$(shell ${AWSCMD} sts get-caller-identity --query 'Account' --output text))
	$(eval ecrDomain=${awsAccount}.dkr.ecr.${AWS_REGION}.amazonaws.com/${BUILD_TAG})

	$(DOCKERCMD) build -t ${ecrDomain} .
	$(DOCKERCMD) push ${ecrDomain}:latest
	$(AWSCMD) ecs update-service --cluster $(APP)-$(NAMESPACE)-cluster --service $(APP)-$(NAMESPACE)-service --force-new-deployment

runDockerLocal:
	PORT=$(PORT) TAG=$(BUILD_TAG) docker-compose up

fmt:
	$(GOFMT) ./...

clean:
	rm -fr $(BUILD_DIR)
	$(DOCKERCMD) stop $(APP)-$(NAMESPACE)-sql || true && $(DOCKERCMD) rm $(APP)-$(NAMESPACE)-sql || true

