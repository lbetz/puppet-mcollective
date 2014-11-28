require 'spec_helper'

describe('mcollective::server', :type => :class) do
  let(:facts) { {:osfamily => 'redhat' } }

  context 'mcollective::server on RedHat' do
    it do
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^libdir\s*=\s*\/usr\/libexec\/mcollective$/)
    end
  end

  context 'mcollective::server on Debian' do
    let (:facts) { {:osfamily => 'debian'} }
    it do
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^libdir\s*=\s*\/usr\/share\/mcollective\/plugins$/)
    end
  end

  context 'mcollective::server on unsupported os' do
    let(:facts) { {:osfamily => 'foo', :operatingsystem => 'foo'} }
    it do
      expect {
        should contain_service('mcollective')
      }.to raise_error(Puppet::Error, /foo isn't supported/)
    end
  end

  context 'mcollective::server with ensure => running, enable => true' do
    let(:params) { {:ensure => 'running', :enable => true} }
    it do
      should contain_service('mcollective').with({
        'ensure' => 'running',
        'enable' => true
      })
    end
  end

  context 'mcollective::server with ensure => stopped, enable => false' do
    let(:params) { {:ensure => 'stopped', :enable => false} }
    it do
      should contain_service('mcollective').with({
        'ensure' => 'stopped',
        'enable' => false
      })
    end
  end

  context 'mcollective::server with unsupported ensure => foo' do
    let(:params) { {:ensure => 'foo'} }
    it do
      expect {
        should contain_service('mcollective')
      }.to raise_error(Puppet::Error, /is not supported for ensure/)
    end
  end

  context 'mcollective::server with unsupported enable => foo' do
    let(:params) { {:enable => 'foo'} }
    it do
      expect {
        should contain_service('mcollective')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end

  context 'mcollective::server with agents => puppet, service' do
    let(:params) { {:agents => ['puppet', 'service']} }
    it do
      should contain_package('mcollective-puppet-agent').with({
        'ensure' => 'present',
      })
      should contain_package('mcollective-service-agent').with({
        'ensure' => 'present',
      })
    end
  end

  context 'mcollective::server with key => base64, cert => base64' do
    let(:params) { {:key => 'base64', :cert => 'base64'} }
    it do
      should contain_file('/etc/mcollective/ssl/servers-private.pem') \
        .with_content(/^base64$/)
      should contain_file('/etc/mcollective/ssl/servers-public.pem') \
        .with_content(/^base64$/)
    end
  end

  context 'mcollective::server with key => false, cert => false (use files outa caller_module)' do
    let(:params) { {:key => false, :cert => false} }
    it do
      should contain_file('/etc/mcollective/ssl/servers-private.pem')
      should contain_file('/etc/mcollective/ssl/servers-public.pem')
    end
  end

  context 'mcollective::server with mqueue => {} (default from params class)' do
    let(:params) { {:mqueue => {}} }
    it do
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.host\s*=\s*puppet$/)
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.port\s*=\s*61614$/)
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.user\s*=\s*mcollective$/)
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.password\s*=\s*marionette$/)
    end
  end

  context 'mcollective::server with mqueue => {host => master, password => foobar}' do
    let (:params) { {:mqueue => {'host' => 'master', 'password' => 'foobar'}} }
    it do
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.host\s*=\s*master$/)
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.port\s*=\s*61614$/)
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.user\s*=\s*mcollective$/)
      should contain_file('/etc/mcollective/server.cfg') \
        .with_content(/^plugin.activemq.pool.1.password\s*=\s*foobar$/)
    end
  end

end
