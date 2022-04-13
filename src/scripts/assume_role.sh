PARAM_ROLE_ARN=$(eval echo "\$$PARAM_ROLE_ARN")

# SEE: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/assume-role-with-web-identity.html
credentials=$(aws sts assume-role-with-web-identity \
  --role-arn "${PARAM_ROLE_ARN}" \
  --web-identity-token "${CIRCLE_OIDC_TOKEN}" \
  --role-session-name "${PARAM_ROLE_SESSION_NAME}" \
  --duration-seconds "${PARAM_DURATION_SECOND}" \
  --query "Credentials" \
  --output "json")

{
  echo "export AWS_ACCESS_KEY_ID=\"$(echo "$credentials" | jq -r '.AccessKeyId')\""
  echo "export AWS_SECRET_ACCESS_KEY=\"$(echo "$credentials" | jq -r '.SecretAccessKey')\""
  echo "export AWS_SESSION_TOKEN=\"$(echo "$credentials" | jq -r '.SessionToken')\""
} >> "${BASH_ENV}"
