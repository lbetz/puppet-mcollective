require 'spec_helper'

describe('mcollective::client::plugin', :type => :define) do
  let(:facts) { {:osfamily => 'redhat'} }

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
        should contain_package('mcollective-foo-client')
      }.to raise_error(Puppet::Error, /foo isn't supported/)
    end
  end

  context 'with ensure => foobar (non valid value)' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'foobar'} }
    it do
      expect {
        should contain_package('mcollective-foo-client')
      }.to raise_error(Puppet::Error, /is not supported for ensure/)
    end
  end

  context 'installs plugin foo' do
    let(:title) { 'foo' }
    it do
      should contain_package('mcollective-foo-client').with({
        'ensure' => 'present',
      })
    end
  end

  context 'removes plugin foo' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_package('mcollective-foo-client').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with plugin => foobar' do
    let(:title) { 'foo' }
    let(:params) { {:plugin => 'foobar'} }
    it do
      should contain_package('mcollective-foobar-client').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with ensure => absent, plugin => foobar' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'absent', :plugin => 'foobar'} }
    it do
      should contain_package('mcollective-foobar-client').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with package => foobaz' do
    let(:title) { 'foo' }
    let(:params) { {:package => 'foobaz'} }
    it do
      should contain_package('foobaz').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with ensure => absent, package => foobaz' do
    let(:title) { 'foo' }
    let(:params) { {:ensure => 'absent', :package => 'foobaz'} }
    it do
      should contain_package('foobaz').with({
        'ensure' => 'absent',
      })
    end
  end

end
