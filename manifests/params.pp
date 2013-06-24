# Class: denyhosts::params
#
class denyhosts::params {

  case $::osfamily {
    'redhat': {
      $secure_log = '/var/log/secure'
      $lock_file = '/var/lock/subsys/denyhosts'
    }
    'debian': {
      $secure_log = '/var/log/auth.log'
      $lock_file = '/var/run/denyhosts.pid'
    }
    'suse': {
      $secure_log = '/var/log/messages'
      $lock_file = '/var/lock/subsys/denyhosts'
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }

}