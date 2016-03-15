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
      inversion_attribute('cassandra-cluster')

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

      def cassandra_command
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
        when '3.4' then '6fea829d5c9e3c34448d519fb9744e645de921d12702cf2bc10b36f17d738794'
        when '3.3' then 'd98e685857d80f9eb93529f7b4f0f2c369ef40974866c8f8ad8edd3d6e0bf7e3'
        when '3.0.4' then '620e2aad12f6609ec3cd5f8ddf7ec16f9ccd9c1ca2a8c4e9acf1f9fc49e24ad0'
        when '3.0.3' then '555417f0d3b5c73fda7388a23becba28f2b87b1d6de082b7afde8d56b29ba4dd'
        when '2.2.5' then '149d2448d0543fb1d5f87a73a7a5e0f589319908426c3a45b20c85563e164f1f'
        when '2.1.13' then '102fffe21b1641696cbdaef0fb5a2fecf01f28da60c81a1dede06c2d8bdb6325'
        end
      end
    end
  end
end
