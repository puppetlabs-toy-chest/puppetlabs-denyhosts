# Class: denyhosts::params
#
class denyhosts::params {

  case $::osfamily {
    'redhat': {
      $secure_log = '/var/log/secure'
    }
    'debian': {
      $secure_log = '/var/log/auth.log'
    }
    'suse': {
      $secure_log = '/var/log/messages'
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }

}