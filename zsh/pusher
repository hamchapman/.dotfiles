alias kc='kubectl -n chatkit'
alias kcd='kc --context deneb'
alias kci='kc --context integration1 -n $(kc --context integration1 get ns | awk "/chatkit/ { print \$1 }")'
alias kcm='kc --context minikube -n chatkit-acceptance'
alias kcp='kc --context us1'
alias kcs='kc --context us1-staging'

rigfor() {
  mfaserial=$AWS_MFA_SERIAL

  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN

  if [ -z "$mfaserial" ]; then
    echo "Warning:: AWS account $1 has no MFA serial, MFA credentials will not be obtained"
  else
    echo "Getting OTP (MFA code)"

    eval $(op signin ahoyhoy)
    otp=`op get totp "AWS Elements"`

    creds="$(aws sts get-session-token --serial-number $mfaserial --token-code $otp)"

    if [ -z "$creds" ]; then
      echo "Failed to retreive temporary credentials"
      return
    fi

    export AWS_ACCESS_KEY_ID=$(printf "%s" "$creds" | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(printf "%s" "$creds" | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(printf "%s" "$creds" | jq -r .Credentials.SessionToken)

    AccessKeyId=$(printf "%s" "$creds" | jq -r .Credentials.AccessKeyId)
    SecretAccessKey=$(printf "%s" "$creds" | jq -r .Credentials.SecretAccessKey)
    SessionToken=$(printf "%s" "$creds" | jq -r .Credentials.SessionToken)
    Expiration=$(printf "%s" "$creds" | jq -r .Credentials.Expiration)
    vault write cubbyhole/AWS_SESSION AccessKeyId=$AccessKeyId SecretAccessKey=$SecretAccessKey SessionToken=$SessionToken Expiration=$Expiration

    if [ $? -ne 0 ]; then
      echo "  Warning: Failed to store credentials in vault. Are you signed in?"
    fi

    echo "Temporary credentials set in environment"
  fi
}

awsauth() {
  DATE=$(which date)
  $DATE --version 2>&1 | grep GNU > /dev/null 2>&1 || DATE=$(which gdate)
  $DATE --version 2>&1 | grep GNU > /dev/null 2>&1 || { echo "GNU date is required but not installed; Unable to fetch credentials"; return; }

  creds=$(vault read -format=json cubbyhole/AWS_SESSION 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "  Warning: No AWS Session stored in vault. Environment not set."
    rigfor
    return
  fi

  expiry=$(printf "%s" "$creds" | jq -r '.data.Expiration')

  estmp=$($DATE -d "$expiry" +%s)
  nowstmp=$($DATE -u +%s)

  if [ "$nowstmp" -gt "$estmp" ]; then
    echo "Stored AWS credentials have expired. Running rigfor"
    rigfor
    return
  fi

  export AWS_ACCESS_KEY_ID=$(printf "%s" "$creds" | jq -r .data.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(printf "%s" "$creds" | jq -r .data.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(printf "%s" "$creds" | jq -r .data.SessionToken)

  echo "AWS credentials restored to environment. Credentials expire $expiry."
}
