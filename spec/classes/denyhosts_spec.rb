require 'spec_helper'

describe 'denyhosts', :type => :class do

  describe 'when deploying on debian' do
    let :facts do
      {
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
          :lsbdistcodename => 'sid',
      }
    end

    describe 'by default' do
      it { should contain_package('denyhosts').with({
            :ensure => 'installed'
           })
      }
      it { should contain_file('/etc/denyhosts.conf').with({
            :owner   => 'root',
            :group   => 'root',
            :mode    => '644',
            :notify  => 'Service[denyhosts]'
           })
      }
      it { should contain_file('/etc/denyhosts.conf').with_content(/ADMIN_EMAIL\s=\sroot@localhost/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SECURE_LOG\s=\s\/var\/log\/auth.log/) }
      it { should contain_service('denyhosts').with({
            :ensure    => 'running',
            :enable    => 'true',
            :hasstatus => 'false',
            :pattern   => 'denyhosts',
            :require   => 'Package[denyhosts]'
           })
      }
      it { should contain_file('/etc/hosts.allow').with({
            :owner   => 'root',
            :group   => 'root',
            :mode    => '644'
           })
      }
    end

    describe 'With no email address and 3 hosts defined' do
      let :params do
        {
            :adminemail => '',
            :allow      => ['host1','host2','host3'],
        }
      end
      it { should contain_file('/etc/denyhosts.conf').with_content(/ADMIN_EMAIL\s=\s+$/) }
      it { should contain_file('/etc/hosts.allow').with_content(/host1\n/) }
      it { should contain_file('/etc/hosts.allow').with_content(/host2\n/) }
      it { should contain_file('/etc/hosts.allow').with_content(/host3\n/) }
    end
  end

  describe 'when deploying on CentOS' do
    let :facts do
      {
          :osfamily        => 'RedHat',
          :operatingsystem => 'CentOS',
      }
    end

    describe 'by default' do
      let :params do
        {
            :adminemail => ''
        }
      end
      it { should contain_file('/etc/denyhosts.conf').with_content(/SECURE_LOG\s=\s\/var\/log\/secure/) }
      it { should contain_file('/etc/hosts.allow')}
    end

  end
end
