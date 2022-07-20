export TOKEN=$1 #terrraform cloud api token
export TF_WORKSPACE=$2 # should be something like azure-tc-demo-automation
export TF_organization=$3 #should be devopsdina
export ARM_CLIENT_ID=$4
export ARM_CLIENT_SECRET=$5
export ARM_SUBSCRIPTION_ID=$6
export ARM_TENANT_ID=$7
export ADMIN_USERNAME=$8
export ADMIN_PASSWORD=$9
export AWS_ACCESS_KEY=${10}
export AWS_SECRET_KEY=${11}

echo "This file contains sensitive output."
echo "ALL curl calls in this file will only show if they error or fail"

if [[ $TF_WORKSPACE == *"azure"* ]]; then
    # Get the workspace id in order to set variables
    export ws_id=$(curl \
        --header "Authorization: Bearer $TOKEN" \
        --header "Content-Type: application/vnd.api+json" \
        https://app.terraform.io/api/v2/organizations/$TF_organization/workspaces/$TF_WORKSPACE | jq .data.id | tr -d '"')
        echo "workspace id for $TF_WORKSPACE is: $ws_id"
        echo "now starting variable creation for $TF_WORKSPACE"

    # Start setting variables...
    cat <<-EOF > /tmp/create-variable-clientid.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"ARM_CLIENT_ID",
        "value":"$ARM_CLIENT_ID",
        "description":"azure client id for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-clientid.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars -s -S

cat <<-EOF > /tmp/create-variable-clientsecret.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"ARM_CLIENT_SECRET",
        "value":"$ARM_CLIENT_SECRET",
        "description":"azure client secret for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-clientsecret.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .

cat <<-EOF > /tmp/create-variable-tenantid.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"ARM_TENANT_ID",
        "value":"$ARM_TENANT_ID",
        "description":"azure tenant id for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-tenantid.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .

cat <<-EOF > /tmp/create-variable-subscriptionid.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"ARM_SUBSCRIPTION_ID",
        "value":"$ARM_SUBSCRIPTION_ID",
        "description":"azure subscription id for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-subscriptionid.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .

cat <<-EOF > /tmp/create-variable-username.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"ADMIN_USERNAME",
        "value":"$ADMIN_USERNAME",
        "description":"azure vm username for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-username.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .

cat <<-EOF > /tmp/create-variable-pw.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"ADMIN_PASSWORD",
        "value":"$ADMIN_PASSWORD",
        "description":"azure vm password for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-pw.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .
fi


if [[ $TF_WORKSPACE == *"aws"* ]]; then
    # Get the workspace id in order to set variables
    export ws_id=$(curl \
        --header "Authorization: Bearer $TOKEN" \
        --header "Content-Type: application/vnd.api+json" \
        https://app.terraform.io/api/v2/organizations/$TF_organization/workspaces/$TF_WORKSPACE | jq .data.id | tr -d '"')
        echo "workspace id for $TF_WORKSPACE is: $ws_id"
        echo "now starting variable creation for $TF_WORKSPACE"

cat <<-EOF > /tmp/create-variable-awsid.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"AWS_ACCESS_KEY",
        "value":"$AWS_ACCESS_KEY",
        "description":"aws id for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-awsid.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .

cat <<-EOF > /tmp/create-variable-awsid.json
    {
    "data": {
        "type":"vars",
        "attributes": {
        "key":"AWS_SECRET_KEY",
        "value":"$AWS_SECRET_KEY",
        "description":"aws secret key for demo",
        "category":"terraform",
        "hcl":false,
        "sensitive":false
        }
    }
    }
EOF
    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-variable-awsid.json \
    https://app.terraform.io/api/v2/workspaces/${ws_id}/vars | jq .
fi