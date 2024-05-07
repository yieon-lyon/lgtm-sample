#! /bin/bash

#platform
CLUSTER_NAME=yieon-cluster-dev
CLUSTER_BY=dev

AWS_PARTITION="aws"
AWS_REGION="$(aws configure list | grep region | tr -s " " | cut -d" " -f3)"
OIDC_ENDPOINT="$(aws eks describe-cluster --name ${CLUSTER_NAME} \
    --query "cluster.identity.oidc.issuer" --output text)"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' \
    --output text)


function CreateControllerPolicy() {
  echo 'CREATE Controller Policy'
  echo '{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Federated": "arn:'${AWS_PARTITION}':iam::'${AWS_ACCOUNT_ID}':oidc-provider/'${OIDC_ENDPOINT#*//}'"
              },
              "Action": "sts:AssumeRoleWithWebIdentity",
              "Condition": {
                  "StringEquals": {
                      "'${OIDC_ENDPOINT#*//}':aud": "sts.amazonaws.com",
                      "'${OIDC_ENDPOINT#*//}':sub": [
                        "system:serviceaccount:monitoring:loki",
                        "system:serviceaccount:monitoring:mimir",
                        "system:serviceaccount:monitoring:tempo"
                      ]
                  }
              }
          }
      ]
  }' > lgtm-trust-policy.json
  aws iam create-role --role-name LGTMRole-${CLUSTER_NAME} \
      --assume-role-policy-document file://lgtm-trust-policy.json


  echo '{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "Statement",
              "Effect": "Allow",
              "Action": [
                  "s3:ListBucket",
                  "s3:GetObject",
                  "s3:GetObjectAcl",
                  "s3:DeleteObject",
                  "s3:PutObject",
                  "s3:PutObjectAcl",
                  "s3:GetObjectTagging",
                  "s3:PutObjectTagging"
              ],
              "Resource": [
                  "arn:aws:s3:::loki-logs-'${CLUSTER_BY}'/*",
                  "arn:aws:s3:::loki-logs-'${CLUSTER_BY}'",
                  "arn:aws:s3:::mimir-blocks-'${CLUSTER_BY}'/*",
                  "arn:aws:s3:::mimir-blocks-'${CLUSTER_BY}'",
                  "arn:aws:s3:::tempo-'${CLUSTER_BY}'/*",
                  "arn:aws:s3:::tempo-'${CLUSTER_BY}'"
              ]
          }
      ]
  }' > s3-policy.json
  aws iam put-role-policy --role-name LGTMRole-${CLUSTER_NAME} \
      --policy-name LGTMPolicy-${CLUSTER_NAME} \
      --policy-document file://s3-policy.json
}

CreateControllerPolicy