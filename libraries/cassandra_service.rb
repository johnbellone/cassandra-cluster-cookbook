#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module CassandraClusterCookbook
  module Resource
    # The `cassandra_service` resource for managing the Cassandra
    # database as a system service.
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    # @since 1.0
    class CassandraService < Chef::Resource
      include Poise
      provides(:cassandra_service)
      include PoiseService::ServiceMixin

      # @!attribute
      # The directory that Cassandra starts in.
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/lib/cassandra')
      # @!attribute
      # The service user for Cassandra.
      # @return [String]
      attribute(:user, kind_of: String, default: 'cassandra')
      # @!attribute
      # The service group for Cassandra.
      # @return [String]
      attribute(:group, kind_of: String, default: 'cassandra')
      # @!attribute
      # The configuration file for Cassandra.
      # @return [String]
      attribute(:config_file, kind_of: String, default: '/etc/cassandra/cassandra.yaml')
      # @!attribute
      # The environment for the Cassandra process.
      # @return [Hash]
      attribute(:environment, kind_of: Hash, default: { 'PATH' => '/usr/local/bin:/usr/bin:/bin' })
      # @!attribute
      # The command to start cassandra.
      # @return [Hash]
      attribute(:command, kind_of: String, required: true)
    end
  end

  module Provider
    # The `cassandra_service` provider for managing the Cassandra
    # database as a system service.
    # @provides cassandra_service
    # @since 1.0
    class CassandraService < Chef::Provider
      include Poise
      provides(:cassandra_service)
      include PoiseService::ServiceMixin

      # @api private
      def action_enable
        notifying_block do
          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end
        end
        super
      end

      # @param [PoiseService::ServiceMixin] service
      # @api private
      def service_options(service)
        service.command(new_resource.command)
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(true)
      end
    end
  end
end
