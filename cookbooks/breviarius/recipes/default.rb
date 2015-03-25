include_recipe 'openssh::default'
include_recipe 'breviarius-jenkins::users'
include_recipe 'breviarius-jenkins::firewall'
include_recipe 'git'
include_recipe 'build-essential::default'
include_recipe 'chef-sugar::default'
include_recipe 'jenkins::master'
include_recipe 'breviarius-jenkins::api'
include_recipe 'breviarius-jenkins::database'
include_recipe 'breviarius-jenkins::manager'
include_recipe 'breviarius-jenkins::plugins'
include_recipe 'breviarius-jenkins::frontend'

# TODO update config.xml with authentication
