if node[:databag_encrypted]
  jenkins_keys = encrypted_data_bag_item('jenkins', 'users')
  breviarius_bot_apikey = encrypted_data_bag_item('github','breviarius-bot')
else
  jenkins_keys = data_bag_item('jenkins', 'users')
  breviarius_bot_apikey = data_bag_item('github','breviarius-bot')
end

jenkins_private_key_credentials 'jenkins' do
  id '2391bdc9-de39-4910-a563-caadef9250be'
  description 'Jenkins user'
  private_key jenkins_keys['private_key']
end

jenkins_password_credentials 'breviarius-bot' do
  id '9c2111e0-aca4-492a-a0c9-16c8e153ce7c'
  description 'Arbor breviarius credentials'
  password breviarius_bot_apikey['breviarius-bot']
end

jenkins_ssh_slave 'executor' do
  description 'Run test suites'
  remote_fs   '/home/jenkins'
  executors   5

  # SSH specific attributes
  host        node['slaves']['server']
  user        'jenkins'
  credentials 'jenkins'
end
