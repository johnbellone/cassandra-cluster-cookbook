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

      property(:version, kind_of: String, required: true)
      property(:install_method, equal_to: %w{binary package}, default: 'binary')
      property(:install_path, kind_of: String, default: '/srv')

      property(:user, kind_of: String, default: 'cassandra')
      property(:group, kind_of: String, default: 'cassandra')
      property(:config_file, kind_of: String, default: '/etc/cassandra/cassandra.yaml')

      property(:environment, kind_of: Hash, default: { 'PATH' => '/usr/local/bin:/usr/bin:/bin' })
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
            version new_resource.version unless new_resource.version.nil?
            action :upgrade
            only_if { new_resource.install_method == 'package' }
          end
        end
        super
      end

      def action_disable
        notifying_block do

        end
        super
      end

      def service_options(service)
        service.command(new_resource.command)
        service.directory(new_resource.current_path)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(true)
      end
    end
  end
end
