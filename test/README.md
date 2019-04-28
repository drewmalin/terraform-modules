# Test App

0. First Time Setup
Initiatlize terraform:
```
> terraform init terraform/
```

1. Deploy App Locally

Build docker image:
```
> docker build -t web-service .
```

Run instantiate docker container:
```
> docker run -p 8080:8080 -d web-service
```

Invoke request:
```
> curl localhost:8080
```

2. Deploy App to AWS

Create SSM parameters. These should pre-exist the AWS stack itself, and should be named in such a way as to include your personal 'namespace' value. Replace <namespace> with that value:

```
> aws ssm put-parameter --name "/<namespace>/db_user" --value "mysupersecretuser" --type "SecureString"

...

> aws ssm put-parameter --name "/<namespace>/db_pass" --value "mysupersecretpass" --type "SecureString"
```

Deploy terraform stack:
```
> terraform apply terraform/
```

Get ECR docker repo URL from terraform output:
```
> terraform output -module=fargate
```

Log into ECR (replace <region> with your region):
```
> aws ecr get-login --no-include-email --region <region>
```

Use the previous output to establish a docker session:
```
> docker login -u AWS -p ...
```

Build a docker image and tag it with the ECR url:
```
> docker build -t <ecr url> .
```

Push the image to ECR:
```
> docker push <ecr url>:latest
```

Trigger an ECS redeployment:
```
> aws --region <region> ecs update-service --cluster <namespace>-cluster --service <namespace>-service --force-new-deployment
```
