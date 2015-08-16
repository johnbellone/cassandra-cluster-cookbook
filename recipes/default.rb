#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#

node.default['java']['jdk_version'] = '7'
node.default['java']['accept_license_agreement'] = true
include_recipe 'java::default'

poise_service_user node['cassandra-cluster']['service_user'] do
  group node['cassandra-cluster']['service_group']
end

cassandra_config node['cassandra-cluster']['service_name'] do |r|
  owner node['cassandra-cluster']['service_user']
  group node['cassandra-cluster']['service_group']

  node['cassandra-cluster']['config'].each_pair { |k, v| r.send(k, v) }
  notifies :restart, "cassandra_service[#{name}]", :delayed
end

cassandra_service node['cassandra-cluster']['service_name'] do |r|
  user node['cassandra-cluster']['service_user']
  group node['cassandra-cluster']['service_group']

  node['cassandra-cluster']['service'].each_pair { |k, v| r.send(k, v) }
end
