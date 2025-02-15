export TOKEN=$1 #Token for the terraform api
export OAUTH_TOKEN_ID=$2 #Oauth token from terraform cloud for github
export GH_REPO_NAME=$3 # should be tc-demo
export GH_ORGANIZATION=$4 # should be devopsdina
export GH_BRANCH=$5 # should be main
export TF_organization=$6 # should be devopsdina
export TF_svnrepo="${GH_ORGANIZATION}/${GH_REPO_NAME}"

# set to current working directory of this script
cd "$(dirname "$0")"

for i in $(find ./../terraform/ -maxdepth 1 -type d | cut -d/ -f5)
do
    export TF_workspace="$i-$GH_REPO_NAME-automation"
    export TF_workingdir="/terraform/$i/"
    echo "Now creating workspace: $TF_workspace"

cat <<-EOF > /tmp/create-workspace.json
    {
        "data": {
        "attributes": {
            "name": "$TF_workspace",
            "working-directory": "$TF_workingdir",
            "speculative-enabled": false,
            "vcs-repo": {
                "display-identifier": "$TF_svnrepo",
                "identifier": "$TF_svnrepo",
                "oauth-token-id": "$OAUTH_TOKEN_ID",
                "branch": "$GH_BRANCH"
            }
        },
        "type": "workspaces"
        }
    }
EOF

    curl --silent --output /dev/null --show-error --fail\
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data @/tmp/create-workspace.json https://app.terraform.io/api/v2/organizations/$TF_organization/workspaces | jq .

done