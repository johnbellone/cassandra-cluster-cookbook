#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module CassandraClusterCookbook
  module Resource
    # @since 1.0.0
    class CassandraService < Chef::Resource
      include Poise
      provides(:cassandra_service)
      include PoiseService::ServiceMixin

      attribute(:version, kind_of: String, required: true)
      attribute(:install_method, equal_to: %w{binary package}, default: 'package')
      attribute(:install_path, kind_of: String, default: '/opt')
      attribute(:remote_url, kind_of: String)
      attribute(:remote_checksum, kind_of: String)

      attribute(:directory, kind_of: String, default: '/var/lib/cassandra')
      attribute(:user, kind_of: String, default: 'cassandra')
      attribute(:group, kind_of: String, default: 'cassandra')
      attribute(:config_file, kind_of: String, default: '/etc/cassandra/cassandra.yaml')

      attribute(:environment, kind_of: Hash, default: { 'PATH' => '/usr/local/bin:/usr/bin:/bin' })
    end
  end

  module Provider
    # @since 1.0.0
    class CassandraService < Chef::Provider
      include Poise
      provides(:cassandra_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          package new_resource.package_name do
            version new_resource.version
            action :upgrade
            only_if { new_resource.install_method == 'package' }
          end

          if new_resource.install_method == 'binary'
            url = new_resource.remote_url % { version: new_resource.version  }
            basename = ::File.basename(url)
            archive = remote_file ::File.join(Chef::Config[:file_cache_path], basename) do
              source url
              checksum new_resource.remote_checksum
            end

            directory new_resource.install_path do
              recursive true
              owner new_resource.user
              group new_resource.group
              mode '0755'
            end

            libarchive_file archive.path do
              owner new_resource.user
              group new_resource.group
              extract_to ::File.join(new_resource.install_path, "cassandra-#{new_resource.version}")
            end
          end

          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end
        end
        super
      end

      def service_options(service)
        service.command("")
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(true)
      end
    end
  end
end
