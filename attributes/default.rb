#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['cassandra-cluster']['config']['path'] = '/etc/cassandra/cassandra.yaml'

default['cassandra-cluster']['version'] = '3.4'

default['cassandra-cluster']['service_name'] = 'cassandra'
default['cassandra-cluster']['service_user'] = 'cassandra'
default['cassandra-cluster']['service_group'] = 'cassandra'

default['cassandra-cluster']['service']['environment']['JMX_PORT'] = 9010
default['cassandra-cluster']['service']['environment']['MX4J_PORT'] = 8081
default['cassandra-cluster']['service']['environment']['MX4J_ADDRESS'] = '-Dmx4jaddress=0.0.0.0'
