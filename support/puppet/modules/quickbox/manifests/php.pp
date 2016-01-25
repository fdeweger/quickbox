class quickbox::php {
    # Bog standard php5 install from puppetlabs-apache. No fancy shmancy xdebug.
    # This won't work if you want CLI php only, or want to use nginx / lighttpd, since it also depends on mpm_module
    # set to prefork in the apache module (you can copy the class include though, that is untested but should work)
    class {'::apache::mod::php' : }
    package { 'php5-mysql' :
        ensure => installed,
        require => Class['::apache::mod::php']
    }

    package { 'php5-curl' :
        ensure => installed,
        require => Class['::apache::mod::php']
    }

    package { 'php5-json' :
	ensure => installed,
	require => Class['::apache::mod::php']
    }

    # Use custom php.ini for apache
    file { '/etc/php5/apache2/php.ini' :
        source => '/vagrant/support/puppet/files/php.ini',
        ensure => present,
        require => Class['::apache::mod::php'],
        notify  => Service['apache2'],
    }

    # Use custom php.ini for CLI
    file { '/etc/php5/cli/php.ini' :
        source => '/vagrant/support/puppet/files/php.ini',
        ensure => present,
        require => Class['::apache::mod::php'],
    }
}
