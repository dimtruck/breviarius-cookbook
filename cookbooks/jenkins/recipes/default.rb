include_recipe 'openssh::default'
include_recipe 'chef-sugar::default'
include_recipe 'git'
include_recipe 'build-essential::default'
include_recipe 'breviarius-jenkins::users'
include_recipe 'breviarius-jenkins::firewall'
include_recipe 'jenkins::master'
include_recipe 'breviarius-jenkins::jobs'
include_recipe 'breviarius-jenkins::plugins'
include_recipe 'breviarius-jenkins::slaves'

# TODO update config.xml with authentication
