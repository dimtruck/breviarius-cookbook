include_recipe 'firewall::default'

firewall 'ufw' do
  action [:enable]
end

if node['security']['firewall']['allow_jumphosts']
  node['security']['firewall']['jumphosts'].each do |name, cidr|
    node['openssh']['server']['port'].each do |port|
      firewall_rule "allow jumphost #{name}:#{cidr} to ssh on #{port}" do
        source cidr
        port port
        action [:allow]
      end
    end
  end
end

if node['security']['firewall']['allow_wideopen']
  node['security']['firewall']['wideopen'].each do |name, network|
    firewall_rule "allow wide open on #{name}:#{network}" do
      interface network
      action [:allow]
    end
  end
end

firewall 'debug firewalls' do
  log_level :high
  action [:enable]
end

firewall_rule 'allow API calls' do
  source '0.0.0.0/0'
  port 80
  interface "eth0"
  action [:allow]
end
