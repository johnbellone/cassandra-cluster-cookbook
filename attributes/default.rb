#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['cassandra-cluster']['config']['path'] = '/etc/cassandra/cassandra.yaml'

default['cassandra-cluster']['version'] = '3.3'

default['cassandra-cluster']['service_name'] = 'cassandra'
default['cassandra-cluster']['service_user'] = 'cassandra'
default['cassandra-cluster']['service_group'] = 'cassandra'

default['cassandra-cluster']['service']['environment']['JMX_PORT'] = 9010
default['cassandra-cluster']['service']['environment']['MX4J_PORT'] = 8081
default['cassandra-cluster']['service']['environment']['MX4J_ADDRESS'] = '-Dmx4jaddress=0.0.0.0'
default['cassandra-cluster']['service']['version'] = '2.2.0'
default['cassandra-cluster']['service']['remote_checksum'] = '6405eb063e7c8a44a485ac12b305c00ad62c526cc021bcce145c29423ae7b0a2'
