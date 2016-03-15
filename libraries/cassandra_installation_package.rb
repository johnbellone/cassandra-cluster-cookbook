#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CassandraClusterCookbook
  module Provider
    # @action create
    # @action remove
    # @provides cassandra_installation
    # @example
    #   cassandra_installation '3.3' do
    #     provider 'package'
    #   end
    # @since 1.0
    class CassandraInstallationPackage < Chef::Provider
      include Poise(inversion: :cassandra_installation)
      provides(:package)
      inversion_attribute('cassandra-cluster')

      # @param [Chef::Node] node
      # @param [Resource::CassandraInstallation] new_resource
      # @return [Hash]
      def self.default_inversion_options(node, new_resource)
        super.merge(
          version: new_resource.version,
          package_name: 'cassandra'
        )
      end

      def action_create
        notifying_block do
          package options[:package_name] do
            source options[:package_source]
            checksum options[:package_source]
            version options[:package_source]
            action :upgrade
          end
        end
      end

      def action_remove
        notifying_block do
          package options[:package_name] do
            source options[:package_source]
            checksum options[:package_source]
            version options[:package_source]
            action :uninstall
          end
        end
      end

      def cassandra_command
      end
    end
  end
end
