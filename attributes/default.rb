#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
default['cassandra-cluster']['config']['path'] = '/etc/cassandra/cassandra.yaml'

default['cassandra-cluster']['service_name'] = 'cassandra'
default['cassandra-cluster']['service_user'] = 'cassandra'
default['cassandra-cluster']['service_group'] = 'cassandra'

default['cassandra-cluster']['service']['environment']['MX4J_PORT'] = 8081
default['cassandra-cluster']['service']['environment']['MX4J_ADDRESS'] = '-Dmx4jaddress=0.0.0.0'
default['cassandra-cluster']['service']['version'] = ''
default['cassandra-cluster']['service']['binary_checksum'] = ''
default['cassandra-cluster']['service']['binary_url'] = "" # rubocop:disable Style/StringLiterals
