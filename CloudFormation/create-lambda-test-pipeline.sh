#!/bin/sh

# 設定ファイルから変数を取得
source $(dirname ${0})/config.txt

# 変数を表示
echo "CodeCommitRepositoryName=$CodeCommitRepositoryName"
echo "SourceBranch=$SourceBranch"
echo "DeployEnvironmentName=$DeployEnvironmentName"
echo "PipelinePrefix=$PipelinePrefix"
echo "TemplateDeployFilename=$TemplateDeployFilename"
echo "Loglevel=$Loglevel"
echo "LogRetentionInDays=$LogRetentionInDays"

# CloudFormationのOutputsを取得
BuildArtifactBucketName=$(aws cloudformation describe-stacks --stack-name lambda-test-resources --query "Stacks[0].Outputs[?OutputKey=='BuildArtifactBucketName'].OutputValue" --output text)
CodeBuildServiceRoleArn=$(aws cloudformation describe-stacks --stack-name lambda-test-resources --query "Stacks[0].Outputs[?OutputKey=='CodeBuildServiceRoleArn'].OutputValue" --output text)
PipelineExecutionRoleArn=$(aws cloudformation describe-stacks --stack-name lambda-test-resources --query "Stacks[0].Outputs[?OutputKey=='PipelineExecutionRoleArn'].OutputValue" --output text)
CloudFormationExecutionRoleArn=$(aws cloudformation describe-stacks --stack-name lambda-test-resources --query "Stacks[0].Outputs[?OutputKey=='CloudFormationExecutionRoleArn'].OutputValue" --output text)

# CloudFormationのOutputsを表示
echo "BuildArtifactBucketName=$BuildArtifactBucketName"
echo "CodeBuildServiceRoleArn=$CodeBuildServiceRoleArn"
echo "PipelineExecutionRoleArn=$PipelineExecutionRoleArn"
echo "CloudFormationExecutionRoleArn=$CloudFormationExecutionRoleArn"

# スタック作成コマンド実行
aws cloudformation create-stack \
      --stack-name lambda-test-pipeline \
      --template-body file://$(dirname ${0})/yaml/lambda-test-pipeline.yaml \
      --capabilities CAPABILITY_NAMED_IAM \
      --parameters \
      ParameterKey=CodeCommitRepositoryName,ParameterValue=$CodeCommitRepositoryName \
      ParameterKey=SourceBranch,ParameterValue=$SourceBranch \
      ParameterKey=DeployEnvironmentName,ParameterValue=$DeployEnvironmentName \
      ParameterKey=PipelinePrefix,ParameterValue=$PipelinePrefix \
      ParameterKey=BuildArtifactBucketName,ParameterValue=$BuildArtifactBucketName \
      ParameterKey=CodeBuildServiceRoleArn,ParameterValue=$CodeBuildServiceRoleArn \
      ParameterKey=PipelineExecutionRoleArn,ParameterValue=$PipelineExecutionRoleArn \
      ParameterKey=CloudFormationExecutionRoleArn,ParameterValue=$CloudFormationExecutionRoleArn \
      ParameterKey=TemplateDeployFilename,ParameterValue=$TemplateDeployFilename \
      ParameterKey=Loglevel,ParameterValue=$Loglevel \
      ParameterKey=LogRetentionInDays,ParameterValue=$LogRetentionInDays
