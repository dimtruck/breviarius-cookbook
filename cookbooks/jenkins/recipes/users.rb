include_recipe 'sudo::default'
include_recipe 'users::default'

node['security']['create_groups'].each do |gid, name|
  log "user: #{name} and id: #{gid}"
  users_manage name do
    group_id gid.to_i
    action [:create]
  end
end if node['security']['create_groups']

node['security']['delete_groups'].each do |gid, name|
  users_manage name do
    group_id gid.to_i
    action [:remove]
  end
end if node['security']['delete_groups']

# set node['authorization']['sudo']['include_sudoers_d'] = true in
# your environment to include these.

node['security']['create_sudo'].each do |name|
  sudo name do
    user "%#{name}"
    nopasswd true
    action [:install]
  end
end if node['security']['create_sudo']

node['security']['delete_sudo'].each do |name|
  sudo name do
    user "%#{name}"
    nopasswd true
    action [:remove]
  end
end if node['security']['delete_sudo']

directory "/home/jenkins/.ssh" do
  owner 'jenkins'
  group 'jenkins'
  mode '0700'
end

template "/home/jenkins/.ssh/config" do
  source 'jenkins_ssh_config.erb'
  owner 'jenkins'
  group 'jenkins'
  mode '0600'
end

log "Databag encrypted: #{node[:databag_encrypted]}"

if node[:databag_encrypted]
  jenkins_keys = encrypted_data_bag_item('jenkins', 'users')
else
  jenkins_keys = data_bag_item('jenkins', 'users')
end

file "/home/jenkins/.ssh/id_rsa" do
  owner 'jenkins'
  group 'jenkins'
  mode '0600'
  content jenkins_keys['private_key']
end

git "/home/jenkins/chef_jenkins" do
  user  'jenkins'
  group 'jenkins'
  repository node[:breviarius_jenkins][:git_repository]
  revision node[:breviarius_jenkins][:git_revision]
  action :sync
  notifies :run, "bash[set_up_jobs]"
end
