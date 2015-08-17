describe_recipe 'cassandra-cluster::default' do
  context 'with default attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe)) }

    it { expect(chef_run).to include_recipe('java::default') }
    it { expect(chef_run).to include_recipe('sysctl::apply') }
    it { expect(chef_run).to include_recipe('selinux::disabled') }
    it { expect(chef_run).to create_poise_service_user('cassandra').with(group: 'cassandra') }
    it do
      expect(chef_run).to create_cassandra_config('cassandra')
      .with(path: '/etc/cassandra/cassandra.conf')
      .with(owner: 'cassandra', group: 'cassandra')
    end
    it do
      expect(chef_run).to create_cassandra_service('cassandra')
      .with(config_file: '/etc/cassandra/cassandra.conf')
      .with(user: 'cassandra', group: 'cassandra')
    end
    it { chef_run }
  end
end
