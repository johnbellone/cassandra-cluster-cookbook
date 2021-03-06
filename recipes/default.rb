#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
include_recipe 'selinux::disabled'
include_recipe 'java-service::default'

poise_service_user node['cassandra-cluster']['service_user'] do
  group node['cassandra-cluster']['service_group']
end

# @see http://docs.datastax.com/en//cassandra/2.0/cassandra/install/installRecommendSettings.html
node.default['sysctl']['params']['vm']['max_map_count'] = 131_072
node.default['sysctl']['params']['vm']['swappiness'] = 0
node.default['sysctl']['params']['vm']['zone_reclaim_mode'] = 0
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

  if node['cassandra-cluster']['config']
    node['cassandra-cluster']['config'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :restart, "cassandra_service[#{service_name}]", :delayed
end

install = cassandra_installation node['cassandra']['version'] do |r|
  if node['cassandra-cluster']['install']
    node['cassandra-cluster']['install'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :restart, "cassandra_service[#{service_name}]", :delayed
end

cassandra_service service_name do |r|
  user node['cassandra-cluster']['service_user']
  group node['cassandra-cluster']['service_group']
  command install.cassandra_command

  if node['cassandra-cluster']['service']
    node['cassandra-cluster']['service'].each_pair { |k, v| r.send(k, v) }
  end
end
