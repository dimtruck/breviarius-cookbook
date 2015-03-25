template "/var/lib/jenkins/hudson.plugins.sonar.SonarPublisher.xml" do
  source "hudson.plugins.sonar.SonarPublisher.xml.erb"
  mode "0644"
  owner "jenkins"
  group "jenkins"
  notifies :restart, 'service[jenkins]', :delayed
  variables(
    :name => 'raxio-sonar-test',
    :server_url => 'http://localhost:9000',
    :database_url => 'jdbc:h2:tcp://localhost:9092/sonar',
    :database_driver => '',
    :database_login => 'sonar',
    :database_password => 'sonar',
    :sonar_login => 'admin',
    :sonar_password => 'admin'
  )
end

template "/var/lib/jenkins/hudson.plugins.sonar.SonarRunnerInstallation.xml" do
  source "hudson.plugins.sonar.SonarRunnerInstallation.xml.erb"
  mode "0644"
  owner "jenkins"
  group "jenkins"
  notifies :restart, 'service[jenkins]', :delayed
end

if node[:databag_encrypted]
  breviarius_bot = encrypted_data_bag_item('github_accounts','breviarius-bot')
else
  breviarius_bot = data_bag_item('github_accounts','breviarius-bot')
end

template "/var/lib/jenkins/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml" do
  source "org.jenkinsci.plugins.ghprb.GhprbTrigger.xml.erb"
  mode "0644"
  owner "jenkins"
  group "jenkins"
  notifies :restart, 'service[jenkins]', :immediately
  variables(
    :username => node[:jenkins][:username],
    :password => breviarius_bot['password'],
    :access_token => breviarius_bot['apikey'],
    :admin_list => node[:jenkins][:ghprb][:admin_list],
    :published_url => node[:jenkins][:ghprb][:published_url]
  )
end

jenkins_plugin 'build-flow-plugin' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'rebuilder' do
  version '1.2.2'
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'ruby-runtime' do
  notifies :restart, 'service[jenkins]', :immediately
end
jenkins_plugin 'build-environment' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'conditional-buildstep' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'dashboard-view' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'envinject' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'gatling' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'git-client' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'git-parameter' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'git' do
  version '2.3.5'
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'github-api' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'github' do
  version '1.11'
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'ghprb' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'groovy' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'ircbot' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'instant-messaging' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'multiple-scms' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'notification' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'parameterized-trigger' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'run-condition' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'shiningpanda' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'build-flow-plugin' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'sonar' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'ssh-agent' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'ssh-credentials' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'ssh' do
  notifies :restart, 'service[jenkins]', :delayed
end
jenkins_plugin 'buildgraph-view' do
  notifies :restart, 'service[jenkins]', :delayed
end

