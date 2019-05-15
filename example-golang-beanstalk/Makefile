APP=example-app
NAMESPACE?=$(subst .,/-,${USER})
AWS_REGION?=us-west-2

PORT=8080

AWSCMD=aws --region $(AWS_REGION)
DOCKERCMD=docker
GOCMD=go
TERRAFORMCMD=terraform

GOBUILD=$(GOCMD) build
GOFMT=$(GOCMD) fmt

SERVICE_DIR=cmd/service
TERRAFORM_DIR=terraform

BUILD_DIR=bin
BUILD_TAG=$(APP)-$(NAMESPACE)
BUILD_VER:=$(shell date +%s)

deployRemote: compile buildDocker pushDockerRemote

deployLocal: compile buildDocker runDockerLocal

compile:
	env GOOS=linux $(GOBUILD) -o $(BUILD_DIR)/$(APP) -ldflags "-s -d -w" -tags netgo -installsuffix netgo -v ./$(SERVICE_DIR)

buildDocker:
	$(DOCKERCMD) build --build-arg port=$(PORT) --build-arg bin=$(APP) -t $(BUILD_TAG):$(BUILD_VER) .

applyTerraform:
	$(TERRAFORMCMD) init $(TERRAFORM_DIR)
	$(TERRAFORMCMD) apply -var="namespace=$(APP)-$(NAMESPACE)" -var="service_port=$(PORT)" $(TERRAFORM_DIR)

destroyTerraform:
	$(TERRAFORMCMD) destroy -var="namespace=$(APP)-$(NAMESPACE)" -var="service_port=$(PORT)" $(TERRAFORM_DIR)

foo:
	cp -r build_template/ build/

	sed -i "s/<ACCOUNT>/$(awsAccount)/" build/Dockerrun.aws.json
	sed -i "s/<REGION>/$(AWS_REGION)/" build/Dockerrun.aws.json
	sed -i "s/<APP>/$(BUILD_TAG)/" build/Dockerrun.aws.json
	sed -i "s/<VERSION>/$(BUILD_VER)/" build/Dockerrun.aws.json
	sed -i "s/<PORT>/$(PORT)/" build/Dockerrun.aws.json
	sed -i "s/<PORT>/$(PORT)/" build/proxy/conf.d/default.conf

	cd build; zip -r ../$(BUILD_TAG)-$(BUILD_VER).zip *

pushDockerRemote:
	$(eval dockerLogin=$(shell ${AWSCMD} ecr get-login --no-include-email))
	${dockerLogin}

	$(eval awsAccount=$(shell ${AWSCMD} sts get-caller-identity --query 'Account' --output text))
	$(eval ecrDomain=${awsAccount}.dkr.ecr.${AWS_REGION}.amazonaws.com)

	$(DOCKERCMD) build --build-arg port=$(PORT) --build-arg bin=$(APP) -t ${ecrDomain}/${BUILD_TAG}:${BUILD_VER} .
	$(DOCKERCMD) push ${ecrDomain}/${BUILD_TAG}:${BUILD_VER}
	
	cp -r build_template/ build/

	sed -i "s/<ACCOUNT>/$(awsAccount)/" build/Dockerrun.aws.json
	sed -i "s/<REGION>/$(AWS_REGION)/" build/Dockerrun.aws.json
	sed -i "s/<APP>/$(BUILD_TAG)/" build/Dockerrun.aws.json
	sed -i "s/<VERSION>/$(BUILD_VER)/" build/Dockerrun.aws.json
	sed -i "s/<PORT>/$(PORT)/" build/Dockerrun.aws.json
	sed -i "s/<PORT>/$(PORT)/" build/proxy/conf.d/default.conf

	cd build ; zip -r ../$(BUILD_TAG)-$(BUILD_VER).zip * ; cd .. ; rm -r build/

	$(AWSCMD) s3 cp $(BUILD_TAG)-$(BUILD_VER).zip s3://$(BUILD_TAG)-versions/$(BUILD_VER).zip

	$(AWSCMD) elasticbeanstalk create-application-version \
		--application-name $(BUILD_TAG) \
		--version-label $(BUILD_VER) \
		--source-bundle S3Bucket=$(BUILD_TAG)-versions,S3Key=$(BUILD_VER).zip
	$(AWSCMD) elasticbeanstalk update-environment \
		--environment-name $(BUILD_TAG)-dev \
		--version-label $(BUILD_VER)

	rm $(BUILD_TAG)-$(BUILD_VER).zip

runDockerLocal:
	PORT=$(PORT) TAG=$(BUILD_TAG) docker-compose up

fmt:
	$(GOFMT) ./...

clean:
	rm -fr $(BUILD_DIR)
	$(DOCKERCMD) stop $(APP)-$(NAMESPACE)-sql || true && $(DOCKERCMD) rm $(APP)-$(NAMESPACE)-sql || true

