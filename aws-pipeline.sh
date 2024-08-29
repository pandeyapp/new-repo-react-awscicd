#!/bin/bash

# Create an S3 bucket for our React app
aws s3 mb s3://my-react-bucket02

# Create an IAM role for the CodePipeline service
aws iam create-role --role-name my-react-app-pipeline-role --assume-role-policy-document file://home/ubuntu/react-app/my-react-app/policy.json

# Get the ARN of the IAM role
ROLE_ARN=$(aws iam get-role --role-name my-react-app-pipeline-role --output text --query 'Role.Arn')

# Create an AWS CodePipeline pipeline
aws codepipeline create-pipeline --name my-react-app-pipeline --role-arn $ROLE_ARN

# Create an AWS CodePipeline source stage
aws codepipeline create-pipeline --stage-name source --pipeline-name my-react-app-pipeline --action-name source --action-type GitHub --repository-name <REPO_NAME> --oauth-token <OAUTH_TOKEN>

# Create an AWS CodePipeline build stage
aws codepipeline create-pipeline --stage-name build --pipeline-name my-react-app-pipeline --action-name build --action-type CodeBuild --project-name my-react-app-build

# Create an AWS CodePipeline deploy stage
aws codepipeline create-pipeline --stage-name deploy --pipeline-name my-react-app-pipeline --action-name deploy --action-type S3 --bucket-name my-react-app-bucket
