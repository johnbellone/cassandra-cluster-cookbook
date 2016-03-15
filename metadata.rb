name 'cassandra-cluster'
maintainer 'John Bellone'
maintainer_email 'jbellone@bloomberg.net'
license 'Apache 2.0'
description 'Application cookbook which installs and configures a Cassandra cluster.'
long_description 'Application cookbook which installs and configures a Cassandra cluster.'
version '1.0.0'
source_url 'https://github.com/bloomberg/cassandra-cluster-cookbook' if defined?(source_url)
issues_url 'https://github.com/bloomberg/cassandra-cluster-cookbook/issues' if defined?(issues_url)

supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 6.6'
supports 'redhat', '>= 6.6'

depends 'java-service'
depends 'libarchive', '~> 0.6'
depends 'poise', '~> 2.2'
depends 'poise-service', '~> 1.0'
depends 'selinux'
depends 'sysctl'
depends 'ulimit'
