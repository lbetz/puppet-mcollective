require 'spec_helper'

describe('mcollective::client', :type => :class) do
  let(:facts) { {:osfamily => 'redhat' } }

  context 'mcollective::client on unsupported os' do
    let(:facts) { {:osfamily => 'foo', :operatingsystem => 'foo'} }
    it do
      expect {
        should contain_package('mcollective-client')
      }.to raise_error(Puppet::Error, /foo isn't supported/)
    end
  end

  context 'mcollective::client with plugins => [puppet, service]' do
    let(:params) { {:plugins => ['puppet', 'service']} }
    it do
      should contain_package('mcollective-puppet-client').with({
        'ensure' => 'present',
      })
      should contain_package('mcollective-service-client').with({
        'ensure' => 'present',
      })
    end
  end

end
