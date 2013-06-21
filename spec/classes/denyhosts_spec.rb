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
      it { should contain_file('/etc/denyhosts.conf').with_content(/HOSTS_DENY\s=\s\/etc\/hosts.deny/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PURGE_DENY\s=/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/BLOCK_SERVICE\s=\ssshd/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_INVALID\s=\s5/) }
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

    describe 'with each option defined' do
      let :params do
        {
            :adminemail => '',
            :purge_deny => '1w',
            :purge_threshold => '0',
            :block_service => 'ALL',
            :deny_threshold_invalid => '3',
        }
      end
      it { should contain_file('/etc/denyhosts.conf').with_content(/SECURE_LOG\s=\s\/var\/log\/secure/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PURGE_DENY\s=\s1w/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PURGE_THRESHOLD\s=\s0/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/BLOCK_SERVICE\s=\sALL/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_INVALID\s=\s3/) }
    end

  end
end
