require 'spec_helper'

describe('mcollective::client::user', :type => :define) do
  let(:facts) { {:osfamily => 'redhat' } }

  context 'contains class mcollective::params' do
    let(:title) { 'foo' }
    it do
      should contain_class('mcollective::params')
    end
  end

  context 'on unsupported os' do
    let(:title) { 'foo' }
    let(:facts) { {:osfamily => 'foo', :operatingsystem => 'foo'} }
    it do
      expect {
        should contain_file('/home/foo/.mcollective')
      }.to raise_error(Puppet::Error, /foo isn't supported/)
    end
  end

  context 'on RedHat' do
    let(:title) { 'foo' }
    it do
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^\s*libdir\s*=\s*\/usr\/libexec\/mcollective$/)
    end
  end

  context 'on Debian' do
    let(:title) { 'foo' }
    let(:facts) { {:osfamily => 'debian'} }
    it do
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^\s*libdir\s*=\s*\/usr\/share\/mcollective\/plugins$/)
    end
  end

  context 'with ensure => foobar (non valid value)' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'foobar'} }
    it do
      expect {
        should contain_file('/home/foo/.mcollective')
      }.to raise_error(Puppet::Error, /is not supported for ensure/)
    end
  end

  context 'with ensure => present' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'present'} }
    it do
      should contain_file('/home/foo/.mcollective').with({
        'ensure' => 'file',
        'owner'  => 'foo',
        'group'  => 'foo',
        'mode'   => '0600',
      })
      should contain_file('/home/foo/.mcollective.d').with({
        'ensure' => 'directory',
        'owner'  => 'foo',
        'group'  => 'foo',
        'mode'   => '0600',
      })
      should contain_file('/home/foo/.mcollective.d/credentials').with({
        'ensure' => 'directory',
        'owner'  => 'foo',
        'group'  => 'foo',
        'mode'   => '0600',
      })
      should contain_file('/home/foo/.mcollective.d/credentials/certs').with({
        'ensure' => 'directory',
        'owner'  => 'foo',
        'group'  => 'foo',
        'mode'   => '0600',
      })
      should contain_file('/home/foo/.mcollective.d/credentials/private_keys').with({
        'ensure' => 'directory',
        'owner'  => 'foo',
        'group'  => 'foo',
        'mode'   => '0600',
      })
    end
  end

  context 'with ensure => absent' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_file('/home/foo/.mcollective').with({
        'ensure' => 'absent',
      })
      should contain_file('/home/foo/.mcollective.d').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with key => false, cert => false' do
    let(:title) { 'foo' }
    let(:params) { {:key => false, :cert => false} }
    it do
      should contain_file('/home/foo/.mcollective.d/credentials/private_keys/foo.pem')
      should contain_file('/home/foo/.mcollective.d/credentials/certs/foo.pem')
    end
  end

  context 'with key => base64, cert => base64' do
    let(:title) { 'foo' }
    let(:params) { {:key => 'base64', :cert => 'base64'} }
    it do
      should contain_file('/home/foo/.mcollective.d/credentials/private_keys/foo.pem') \
        .with_content(/^base64$/)
      should contain_file('/home/foo/.mcollective.d/credentials/certs/foo.pem') \
        .with_content(/^base64$/)
    end
  end

  context 'with server_cert => base64' do
    let(:title) { 'foo' }
    let(:params) { {:server_cert => 'base64'} }
    it do
      should contain_file('/home/foo/.mcollective.d/credentials/certs/mcollective-servers.pem') \
        .with_content(/^base64$/)
    end
  end

  context 'with server_cert => false' do
    let(:title) { 'foo' }
    let(:params) { {:server_cert => 'base64'} }
    it do
      should contain_file('/home/foo/.mcollective.d/credentials/certs/mcollective-servers.pem')
    end
  end

  context 'with certname => foobar' do
    let(:title) { 'foo' }
    let(:params) { {:certname => 'foobar'} }
    it do
      should contain_file('/home/foo/.mcollective.d/credentials/private_keys/foobar.pem').with({
        'mode' => '0600',
      })
      should contain_file('/home/foo/.mcollective.d/credentials/certs/foobar.pem').with({
        'mode' => '0600',
      })
    end
  end

  context 'with user => foobar, group => foobaz' do
    let(:title) { 'foo' }
    let(:params) { {:user => 'foobar', :group => 'foobaz'} }
    it do
      should contain_file('/home/foobar/.mcollective').with({
        'owner'  => 'foobar',
        'group'  => 'foobaz',
      })
      should contain_file('/home/foobar/.mcollective.d').with({
        'owner'  => 'foobar',
        'group'  => 'foobaz',
      })
    end
  end

  context 'with home => /home/foobar' do
    let(:title) { 'foo' }
    let(:params) { {:home => '/home/foobar'} }
    it do
      should contain_file('/home/foobar/.mcollective').with({
        'owner'  => 'foo',
        'group'  => 'foo',
      })
      should contain_file('/home/foobar/.mcollective.d').with({
        'owner'  => 'foo',
        'group'  => 'foo',
      })
    end
  end

  context 'with home => foobar (not an absolute path)' do
    let(:title) { 'foo' }
    let(:params) { {:home => 'foobar'} }
    it do
      expect {
        should contain_file('/home/foobar/.mcollective')
      }.to raise_error(Puppet::Error, /is not an absolute path/)
    end
  end

  context 'with mqueue => {} (default from params class)' do
    let(:title) { 'foo' }
    let(:params) { {:mqueue => {}} }
    it do
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.host\s*=\s*puppet$/)
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.port\s*=\s*61614$/)
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.user\s*=\s*mcollective$/)
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.password\s*=\s*marionette$/)
    end
  end

  context 'with mqueue => {host => master, password => foobar}' do
    let(:title) { 'foo' }
    let (:params) { {:mqueue => {'host' => 'master', 'password' => 'foobar'}} }
    it do
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.host\s*=\s*master$/)
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.port\s*=\s*61614$/)
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.user\s*=\s*mcollective$/)
      should contain_file('/home/foo/.mcollective') \
        .with_content(/^plugin.activemq.pool.1.password\s*=\s*foobar$/)
    end
  end

end
