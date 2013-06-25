require 'spec_helper'

describe 'denyhosts', :type => :class do

  describe 'when deploying on debian' do
    let :facts do
      {
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
          :lsbdistcodename => 'sid',
          :fqdn            => 'localhost.localdomain'
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
      it { should contain_file('/etc/denyhosts.conf').with_content(/SECURE_LOG\s=\s\/var\/log\/auth\.log/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/HOSTS_DENY\s=\s\/etc\/hosts\.deny/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PURGE_DENY\s=/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/BLOCK_SERVICE\s=\ssshd/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_INVALID\s=\s5/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_VALID\s=\s10/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_ROOT\s=\s1/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_RESTRICTED\s=\s1/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/WORK_DIR\s=\s\/var\/lib\/denyhosts/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS\s=\sYES/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/HOSTNAME_LOOKUP\s=\sYES/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/LOCK_FILE\s=\s\/var\/run\/denyhosts\.pid/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_HOST\s=\slocalhost/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_PORT\s=\s25/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^SMTP_USERNAME/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^SMTP_PASSWORD/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_FROM\s=\sDenyHosts\s<nobody@localhost\.localdomain>/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_SUBJECT\s=\sDenyHosts\sReport/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^SMTP_DATE_FORMAT/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^SYSLOG_REPORT/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^ALLOWED_HOSTS_HOSTNAME_LOOKUP/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_VALID\s=\s5d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_ROOT\s=\s25d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_RESTRICTED\s=\s25d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_INVALID\s=\s10d/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^RESET_ON_SUCCESS/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^PLUGIN_DENY/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^PLUGIN_PURGE/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^USERDEF_FAILED_ENTRY_REGEX/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_LOG\s=\s\/var\/log\/denyhosts/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^DAEMON_LOG_TIME_FORMAT/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/^DAEMON_LOG_MESSAGE_FORMAT/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_SLEEP\s=\s30s/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_PURGE\s=\s1h/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_SERVER\s=\shttp:\/\/xmlrpc.denyhosts.net:9911/) }
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
      it { should contain_file('/etc/denyhosts.conf').with_content(/LOCK_FILE\s=\s\/var\/lock\/subsys\/denyhosts/) }
    end

    describe 'with each option defined' do
      let :params do
        {
            :adminemail => '',
            :purge_deny => '1w',
            :purge_threshold => '0',
            :block_service => 'ALL',
            :deny_threshold_invalid => '3',
            :deny_threshold_valid => '15',
            :deny_threshold_root => '2',
            :deny_threshold_restricted => '2',
            :work_dir => '/opt/denyhosts/var',
            :suspicious_login_report_allowed_hosts => 'NO',
            :hostname_lookup => 'NO',
            :lock_file => '/tmp/denyhosts.lock',
            :smtp_host => 'securemailhost.localdomain',
            :smtp_port => '465',
            :smtp_username => 'foo',
            :smtp_password => 'bar',
            :smtp_from => false,
            :smtp_subject => 'IMPORTANT - Deny Host Report',
            :smtp_date_format => '%A, %d %B %Y %H:%M:%S %z',
            :syslog_report => 'YES',
            :allowed_hosts_hostname_lookup => 'YES',
            :age_reset_valid => '10d',
            :age_reset_root => '30d',
            :age_reset_restricted => '30d',
            :age_reset_invalid => '15d',
            :reset_on_success => 'YES',
            :plugin_deny => '/usr/bin/true',
            :plugin_purge => '/usr/bin/true',
            :userdef_failed_entry_regex => 'break in attempt from (?P.*)',
            :daemon_log => '/var/log/denyhosts.log',
            :daemon_log_time_format => '%b %d %H:%M:%S',
            :daemon_log_message_format => '%(asctime)s - %(name)-12s: %(levelname)-8s %(message)s',
            :daemon_sleep => '35s',
            :daemon_purge => '5h',
            :sync_server => 'http://xmlrpc.localdomain:9911',
        }
      end
      it { should contain_file('/etc/denyhosts.conf').with_content(/SECURE_LOG\s=\s\/var\/log\/secure/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PURGE_DENY\s=\s1w/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PURGE_THRESHOLD\s=\s0/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/BLOCK_SERVICE\s=\sALL/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_INVALID\s=\s3/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_VALID\s=\s15/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_ROOT\s=\s2/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DENY_THRESHOLD_RESTRICTED\s=\s2/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/WORK_DIR\s=\s\/opt\/denyhosts\/var/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS\s=\sNO/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/HOSTNAME_LOOKUP\s=\sNO/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/LOCK_FILE\s=\s\/tmp\/denyhosts\.lock/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_HOST\s=\ssecuremailhost\.localdomain/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_PORT\s=\s465/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_USERNAME\s=\sfoo/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_PASSWORD\s=\sbar/) }
      it { should_not contain_file('/etc/denyhosts.conf').with_content(/SMTP_FROM/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_SUBJECT\s=\sIMPORTANT\s-\sDeny\sHost\sReport/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SMTP_DATE_FORMAT\s=\s%A,\s%d\s%B\s%Y\s%H:%M:%S\s%z/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SYSLOG_REPORT\s=\sYES/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/ALLOWED_HOSTS_HOSTNAME_LOOKUP\s=\sYES/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_VALID\s=\s10d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_ROOT\s=\s30d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_RESTRICTED\s=\s30d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/AGE_RESET_INVALID\s=\s15d/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/RESET_ON_SUCCESS\s=\sYES/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PLUGIN_DENY\s=\s\/usr\/bin\/true/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/PLUGIN_PURGE\s=\s\/usr\/bin\/true/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/USERDEF_FAILED_ENTRY_REGEX\s=\sbreak\sin\sattempt\sfrom\s\(\?P\.\*\)/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_LOG\s=\s\/var\/log\/denyhosts.log/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_LOG_TIME_FORMAT\s=\s%b\s%d\s%H:%M:%S/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_LOG_MESSAGE_FORMAT\s=\s%\(asctime\)s\s-\s%\(name\)-12s:\s%\(levelname\)-8s\s%\(message\)s/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_SLEEP\s=\s35s/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/DAEMON_PURGE\s=\s5h/) }
      it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_SERVER\s=\shttp:\/\/xmlrpc.localdomain:9911/) }
    end

  end
end
