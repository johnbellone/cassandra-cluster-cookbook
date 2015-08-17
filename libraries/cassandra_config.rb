#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise'

module CassandraClusterCookbook
  module Resource
    # @since 1.0.0
    class CassandraConfig < Chef::Resource
      include Poise(fused: true)
      provides(:cassandra_config)

      property(:path, kind_of: String, name_attribute: true)
      property(:owner, kind_of: String, default: 'cassandra')
      property(:group, kind_of: String, default: 'cassandra')

      property(:cluster_name, kind_of: String, default: 'cassandra')

      def to_yaml
      end

      action(:create) do
        notifying_block do
          directory Dir.dirname(new_resource.path) do
            recursive true
            owner new_resource.owner
            group new_resource.group
          end

          file new_resource.path do
            content new_resource.to_yaml
            owner new_resource.owner
            group new_resource.group
          end
        end
      end

      action(:delete) do
        file new_resource.path do
          action :delete
        end
      end
    end
  end
end
