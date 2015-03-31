Jenkins cookbook wrapper for Breviarius

### Setup

Create knife.rb file a la this:

```
current_dir = File.dirname(__FILE__)

user = ENV["CHEF_USER"]
OS_PASSWORD = ENV["OS_PASSWORD"] || 'nopass'
OS_USERNAME = ENV["OS_USERNAME"] || 'nopass'
OS_REGION_NAME = ENV["OS_REGION_NAME"] || 'dfw'

cookbook_path ["#{current_dir}/cookbooks"]
node_path "#{current_dir}/nodes"
role_path "#{current_dir}/roles"
environment_path "#{current_dir}/environments"
data_bag_path "#{current_dir}/data_bags"
client_key "#{ENV["HOME"]}/.chef/#{ENV["CHEF_USERNAME"]}/#{user}.pem"
knife[:berkshelf_path] = "#{current_dir}/cookbooks"

log_level                :info
log_location             STDOUT
node_name                user
validation_client_name   "#{ENV["CHEF_USERNAME"]}-validator"
validation_key           "#{ENV["HOME"]}/.chef/#{ENV["CHEF_USERNAME"]}/#{ENV["CHEF_USERNAME"]}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{ENV["CHEF_USERNAME"]}"
cache_type               "BasicFile"
cache_options( :path => "#{ENV["HOME"]}/.chef/#{ENV["OS_USERNAME"]}/checksums" )
```

Source environment variables:

```
export OS_AUTH_URL=?
export OS_AUTH_SYSTEM=?
export OS_REGION_NAME=?
export OS_USERNAME=?
export OS_PASSWORD=?

export CHEF_USER=?
export CHEF_USERNAME=?
```

Create CHEF_USERNAME directory:

```
mkdir ~/.chef/CHEF_USERNAME
```

Copy over your client pem to that directory

Apply berks and update environments

```
berks apply ENV
knife environment show -Fj ENV  | jq --sort-keys . > ./.chef/environments/ENV.json
ls -1 ./.chef/roles/*.json | xargs -n1 knife role from file
ls -1 ./.chef/environments/*.json | xargs -n1 knife environment from file
berks update
berks upload
```

Data Bags:
==========

Create secret key:

```
openssl rand -base64 512 | tr -d '\r\n' > encrypted_data_bag_secret
```


Create new Jenkins master:
=========================

Set rax env variables:

```
ENV=?
ROLE="role[?]"
NAME="${ENV}-jenkins-master"
IMG="255df5fb-e3d4-45a3-9a07-c976debf7c14"
FLAVOR="performance1-2"
SECRET="$HOME/.chef/CHEF_USERNAME/SECRET"
```

Validate what you're about to add:

```
echo "Finna create ${NAME} with role of ${ROLE} in ${ENV} using image ${IMG} on flavor ${FLAVOR}.  Cool?"
```

Create a server:

```
knife rackspace server create -r "${ROLE}" --server-name \
 "${NAME}" --node-name "${NAME}" \
 --image "${IMG}" \
 --flavor "${FLAVOR}" --environment ${ENV} \
 --secret-file ${SECRET} \
 --no-tcp-test-ssh --ssh-wait-timeout 100 
```
