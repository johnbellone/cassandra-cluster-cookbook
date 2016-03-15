#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CassandraClusterCookbook
  module Resource
    # The `cassandra_config` resource for managing the Cassandra
    # database configuration.
    # @action create
    # @action remove
    # @provides cassandra_config
    # @see http://docs.datastax.com/en/cassandra/1.2/cassandra/configuration/configCassandra_yaml_r.html
    # @since 1.0
    class CassandraConfig < Chef::Resource
      include Poise(fused: true)
      provides(:cassandra_config)

      # @!attribute path
      # The Cassandra configuration file path.
      # @return [String]
      attribute(:path, kind_of: String, name_attribute: true)
      # @!attribute owner
      # The Cassandra configuration file owner.
      # @return [String]
      attribute(:owner, kind_of: String, default: 'cassandra')
      # @!attribute group
      # The Cassandra configuration file group.
      # @return [String]
      attribute(:group, kind_of: String, default: 'cassandra')
      # @!attribute mode
      # The Cassandra configuration file mode.
      # @return [String]
      attribute(:mode, kind_of: String, default: '0440')

      attribute(:auto_bootstrap, equal_to: [true, false], default: true)
      attribute(:auto_snapshot, equal_to: [true, false], default: true)
      attribute(:broadcast_address, kind_of: String)
      attribute(:commitlog_directory, kind_of: String, default: '/var/lib/cassandra/commitlog')
      attribute(:cluster_name, kind_of: String, default: 'cassandra')
      attribute(:data_file_directories, kind_of: String, default: '/var/lib/cassandra/data')
      attribute(:disk_failure_policy, equal_to: %w{stop best_effort ignore}, default: 'stop')
      attribute(:internode_compression, equal_to: %w{all dc none}, default: 'all')
      attribute(:incremental_backups, equal_to: [true, false], default: false)
      attribute(:listen_address, kind_of: String, default: 'localhost')
      attribute(:native_transport_port, kind_of: Integer, default: 9042)
      attribute(:native_transport_min_threads, kind_of: Integer, default: 16)
      attribute(:native_transport_max_threads, kind_of: Integer, default: 128)
      attribute(:rpc_address, kind_of: String, default: 'localhost')
      attribute(:rpc_port, kind_of: Integer, default: 9160)
      attribute(:snapshot_before_compaction, equal_to: [true, false], default: false)
      attribute(:ssl_storage_port, kind_of: Integer, default: 7001)
      attribute(:start_native_transport, equal_to: [true, false], default: false)
      attribute(:start_rpc, equal_to: [true, false], default: true)
      attribute(:saved_caches_directory, kind_of: String, default: '/var/lib/cassandra/saved_caches')
      attribute(:storage_port, kind_of: Integer, default: 7000)
      attribute(:options, options_collector: true, default: {})

      # @return [Hash]
      # @api private
      def content
        for_keeps = %i{auto_bootstrap auto_snapshot broadcast_address commitlog_directory
          cluster_name data_file_directories disk_failure_policy internode_compression
          incremental_backups listen_address native_transport_port native_transport_min_threads
          native_transport_madx_threads rpc_address rpc_port snapshot_before_compaction ssl_storage_port
          start_native_transport start_rpc saved_caches_directory storage_port}
        for_keeps.merge(options).uniq!
        to_hash.keep_if { |k, _| for_keeps.include?(k) }
      end

      action(:create) do
        notifying_block do
          directory ::Dir.dirname(new_resource.path) do
            recursive true
            owner new_resource.owner
            group new_resource.group
            mode '0755'
          end

          rc_file new_resource.path do
            type 'yaml'
            content new_resource.content
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
          end
        end
      end

      action(:remove) do
        file new_resource.path do
          action :delete
        end
      end
    end
  end
end
