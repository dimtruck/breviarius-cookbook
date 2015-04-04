# Encoding: utf-8

name 'breviarius-jenkins'
maintainer 'Dimitry Ushakov'
maintainer_email 'dimalg@gmail.com'
license 'All rights reserved Breviarius'
description 'Installs/Configures Breviarius Jenkins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

%w(ubuntu).each do |os|
  supports os
end

%w(
  jenkins apt sudo firewall users openssh
  docker runit git python
  chef-sugar auto-update build-essential
).each do |dep|
  depends dep
end
