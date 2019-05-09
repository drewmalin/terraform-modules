# Example: Golang + Fargate + Aurora

## Prerequisites

* AWS CLI
* Account, IAM User

## Local Deployment

Deploy a local app and SQL database (using Docker, docker-compose):
```
> make deployLocal
```

Access:
```
> curl localhost:8080
```

## Remote Deployment

Deploy the terraform stack:
```
> make applyTerraform
```

Deploy the app:
```
> make deployRemote
```

Access:
```
> terraform output -module=alb
(note the outputted url)
```

Cleanup:
```
> make destroyTerraform
```
