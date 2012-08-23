puppetlabs-denyhosts
====================

This module supplies basic configuration for DenyHosts

### Class: denyhosts

It provides a class that controls which hosts are allowed to connect and the email address to alert on violations, for example:

    class { "denyhosts":
      adminemail => "",
      allow      => [ 'host1', 'host2', 'host3' ],
    }

The email address defaults to root@localhost.

You could also use a hiera look-up to query the data:

    class { "denyhosts":
      adminemail => "",
      allow      => hiera("allowhosts"),
    }


