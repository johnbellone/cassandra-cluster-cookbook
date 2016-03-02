#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CassandraClusterCookbook
  module Provider
    # A `cassandra_installation` provider which manages the
    # installation of Cassandra from a binary archive.
    # @action create
    # @action remove
    # @provides cassandra_installation
    # @since 1.0
    class CassandraInstallationBinary < Chef::Provider
      include Poise(inversion: :cassandra_installation)
      provides(:binary)

      # @param [Chef::Node] _node
      # @param [Resource::CassandraInstallation] _resource
      # @return [TrueClass, FalseClass]
      def self.provides_auto?(_node, _resource)
        true
      end

      # @param [Chef::Node] node
      # @param [Resource::CassandraInstallation] new_resource
      # @return [Hash]
      def self.default_inversion_options(node, new_resource)
        super.merge(
          version: new_resource.version,
          archive_url: default_archive_url,
          archive_basename: default_archive_basename(node, new_resource),
          archive_checksum: default_archive_checksum(node, new_resource),
          extract_to: '/opt/cassandra'
        )
      end

      def action_create
        archive_url = options[:archive_url] % {
          version: options[:version],
          basename: options[:archive_basename]
        }

        notifying_block do
          include_recipe 'libarchive::default'

          archive = remote_file options[:archive_basename] do
            path ::File.join(Chef::Config[:file_cache_path], name)
            source archive_url
            checksum options[:archive_checksum]
          end

          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
          end

          libarchive_file options[:archive_basename] do
            path archive.path
            mode options[:extract_mode]
            owner options[:extract_owner]
            group options[:extract_group]
            extract_to ::File.join(options[:extract_to], new_resource.version)
            extract_options options[:extract_options]
          end
        end
      end

      def action_remove
        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
            action :delete
          end
        end
      end

      # @return [String]
      # @api private
      def self.default_archive_url
        "http://apache.cs.utah.edu/cassandra/%{version}/%{basename}"
      end

      # @param [Chef::Node] node
      # @param [Resource::CassandraInstallation] resource
      # @return [String]
      # @api private
      def self.default_archive_basename(node, resource)
        "apache-cassandra-#{resource.version}-bin.tar.gz"
      end

      # @param [Chef::Node] node
      # @param [Resource::CassandraInstallation] resource
      # @return [String]
      # @api private
      def self.default_archive_checksum(node, resource)
        case resource.version
        when '3.3' then ''
        when '3.0.3' then ''
        when '2.2.5' then ''
        when '2.1.13' then ''
        end
      end
    end
  end
end
