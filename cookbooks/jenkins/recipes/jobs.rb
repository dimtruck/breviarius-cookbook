bash 'set_up_jobs' do
  user  'root'
  cwd '/home/jenkins/chef_jenkins/autocreator'
  code <<-EOH
  sudo pip install -rrequirements.txt
  sudo ./autocreator.py -d jobs -job breviarius -url "localhost:8080" -http
  EOH
end

template "/var/lib/jenkins/config.xml" do
  source "config.xml.erb"
  mode "0644"
  owner "jenkins"
  group "jenkins"
  notifies :restart, 'service[jenkins]', :delayed
  variables(
    :lists => [
      {
        :name => 'Nightly Build Flow',
        :jobs => [
          'breviarius_master_build_flow',
          'breviarius_build',
          'breviarius_unit_tests',
          'breviarius_functional_tests',
          'breviarius_performance_tests',
          'breviarius_sonar',
          'breviarius_snapshot_deployer',
          'breviarius_cleanup'
        ]
      },
      {
        :name => 'Patch Build Flow',
        :jobs => [
          'breviarius_functional_tests',
          'breviarius_patch_build_flow',
          'breviarius_patch_trigger',
          'breviarius_performance_tests',
          'breviarius_unit_tests'
        ]
      },
      {
        :name => 'Deployment Flow',
        :jobs => [
          'breviarius_staging_deployment_build_flow',
          'breviarius_staging_dark_deployment_build_flow',
          'breviarius_release_deployer',
          'breviarius_staging_dark_nodes_deployer',
          'breviarius_staging_dark_nodes_deployer_rescue',
          'breviarius_staging_live_deployment_build_flow',
          'breviarius_staging_live_nodes_deployer',
          'breviarius_staging_dark_nodes_deployer_rescue',
          'breviarius_staging_release_deployer_cleanup',
          'breviarius_prod_deployment_build_flow',
          'breviarius_prod_dark_deployment_build_flow',
          'breviarius_prod_dark_nodes_deployer',
          'breviarius_prod_dark_nodes_deployer_rescue',
          'breviarius_prod_live_deployment_build_flow',
          'breviarius_prod_live_nodes_deployer',
          'breviarius_prod_dark_nodes_deployer_rescue',
          'breviarius_prod_release_deployer_cleanup'
        ]
      }
    ]
  )
end
