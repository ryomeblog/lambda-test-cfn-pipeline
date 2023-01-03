#!/bin/sh

# 設定ファイルから変数を取得
source $(dirname ${0})/config.txt

# 変数を表示
echo "CodeCommitRepositoryName=$CodeCommitRepositoryName"
echo "BucketName=$BucketName"
echo "RoleNamePrefix=$RoleNamePrefix"

# スタック作成コマンド実行
aws cloudformation create-stack \
      --stack-name lambda-test-resources \
      --template-body file://$(dirname ${0})/yaml/lambda-test-resources.yaml \
      --capabilities CAPABILITY_NAMED_IAM \
      --parameters \
      ParameterKey=BuildArtifactBucketName,ParameterValue=$BucketName \
      ParameterKey=RoleNamePrefix,ParameterValue=$RoleNamePrefix \
      ParameterKey=CodeCommitRepositoryName,ParameterValue=$CodeCommitRepositoryName
