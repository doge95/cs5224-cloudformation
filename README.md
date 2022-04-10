# cs5224-cloudformation
## Setup Development Environment
Install below in computer:
- pyenv
- nvm
- nodejs
- jq
At the root directory level, run below to setup the deployment environment:
```
make setup
```

## Configure AWS CLI
Create a user with administrator access and generate the access key.
```
$ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: us-east-1
Default output format [None]: json
```
## Build & Deploy Stack to AWS CloudFormation
### Steps
1. Define environment in the environment variable
2. Go the component foler (eg. users)
3. Build the component
3. Package and upload the artifacts to AWS S3
4. Deploy the stack in AWS CloudFormation
```
$ export ENVIRONMENT=prod
$ cd users
$ make build
$ make package
$ make deploy
```
To clean created resrouces and delete the stack in CloudFormation,
```
$ make clean
```
