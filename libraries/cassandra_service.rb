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
