#
# Cookbook: cassandra-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CassandraClusterCookbook
  module Resource
    # A `cassandra_installation` resource which manages the
    # installation of the Cassandra database.
    # @action create
    # @action remove
    # @since 1.0
    class CassandraInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:cassandra_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute version
      # The version of Cassandra to install.
      # @return [String]
      attribute(:version, kind_of: String, name_attribute: true)
    end
  end
end
