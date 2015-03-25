# Encoding: utf-8

name 'breviarius-application'
maintainer 'Dimitry Ushakov'
maintainer_email 'dimalg@gmail.com'
license 'All rights reserved Breviarius'
description 'Installs/Configures Breviarius Application'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

%w(ubuntu).each do |os|
  supports os
end

%w(
  apt sudo firewall users openssh
  docker runit git
  chef-sugar auto-update build-essential
).each do |dep|
  depends dep
end
