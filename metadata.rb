# Encoding: utf-8

name 'breviarius'
maintainer 'Dimitry Ushakov'
maintainer_email 'dimalg@gmail.com'
license 'All rights reserved Breviarius'
description 'Installs/Configures Arbor Lab'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.5.1'

%w(ubuntu).each do |os|
  supports os
end

%w(
  apt sudo firewall users openssh
  docker runit
  chef-sugar auto-update build-essential
).each do |dep|
  depends dep
end

# temp disabled
# mariadb rabbitmq repose nginx haproxy