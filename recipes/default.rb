#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
include_recipe 'selinux::disabled'

node.default['java']['jdk_version'] = '8'
node.default['java']['accept_license_agreement'] = true
include_recipe 'java::default'

poise_service_user node['cassandra-cluster']['service_user'] do
  group node['cassandra-cluster']['service_group']
end

# @see http://docs.datastax.com/en//cassandra/2.0/cassandra/install/installRecommendSettings.html
node.default['sysctl']['params']['vm']['max_map_count'] = 131_072
node.default['sysctl']['params']['vm']['swappiness'] = 0
include_recipe 'sysctl::apply'

service_name = node['cassandra-cluster']['service_name']
user_ulimit node['cassandra-cluster']['service_user'] do
  memory_limit 'unlimited'
  filehandle_limit 100_000
  process_limit 32_768
  notifies :restart, "cassandra_service[#{service_name}]", :delayed
end

cassandra_config service_name do |r|
  owner node['cassandra-cluster']['service_user']
  group node['cassandra-cluster']['service_group']

  node['cassandra-cluster']['config'].each_pair { |k, v| r.send(k, v) }
  notifies :restart, "cassandra_service[#{name}]", :delayed
end

cassandra_service service_name do |r|
  user node['cassandra-cluster']['service_user']
  group node['cassandra-cluster']['service_group']

  node['cassandra-cluster']['service'].each_pair { |k, v| r.send(k, v) }
end
