# Class: denyhosts::params
#
class denyhosts::params {

  case $::osfamily {
    'redhat': {
      $secure_log = '/var/log/secure'
      $lock_file = '/var/lock/subsys/denyhosts'
      $denyhosthasservice = true
    }
    'debian': {
      $secure_log = '/var/log/auth.log'
      $lock_file = '/var/run/denyhosts.pid'
      $denyhosthasservice = true
    }
    'suse': {
      $secure_log = '/var/log/messages'
      $lock_file = '/var/lock/subsys/denyhosts'
      $denyhosthasservice = true
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }

}
