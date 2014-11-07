include_recipe 'docker'

docker_image 'node' do
  tag 'nodeTag'
  source 'Dockerfile'
  action :build_if_missing
end

docker_container 'node' do
  rm
  detach true
  port '8080:8888'
end