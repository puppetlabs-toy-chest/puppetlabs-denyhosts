class denyhosts (
  $adminemail = "root@localhost",
  $allow      = [],
  $secure_log = $denyhosts::params::secure_log
  ) {

  include denyhosts::params

  validate_array($allow)

  package { "denyhosts": ensure => installed; }

  file { "/etc/denyhosts.conf":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("denyhosts/denyhosts.conf.erb"),
    notify  => Service["denyhosts"],
  }

  service {
    "denyhosts":
      ensure    => running,
      enable    => true,
      hasstatus => false,
      pattern   => "denyhosts",
      require   => Package["denyhosts"],
  }

  file {
    "/etc/hosts.allow":
      content => template("denyhosts/hosts.allow.erb"),
      owner   => root,
      group   => root,
      mode    => 644,
  }

}
