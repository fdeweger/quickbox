# Set path for all exec calls globally
Exec {
    path => ["/bin", "/bin/usr"]
}

# Uncomment to include apache, mysql, php etc etc
include quickbox::apache
include quickbox::php
include quickbox::mysql

# Have all you handy-dandy aliases under version control and in your box :)
file { '/home/vagrant/.bash_aliases' :
    ensure => link,
    target => '/vagrant/support/puppet/files/.bash_aliases',
}

# MOTD File
file { '/etc/motd' :
    ensure => present,
    source => '/vagrant/support/puppet/files/motd',
}

# Automagically goto /vagrant when using vagrant ssh
exec { "cd-vagrant" :
    command => "echo 'cd /vagrant' >> /home/vagrant/.bashrc",
    unless => "grep -c 'cd /vagrant' /home/vagrant/.bashrc"
}

# Install git in the guest, since every half-decent package man
package { 'git' :
    ensure => installed
}

# Install build essentials, because this box is created for experimental software so it wouldn't be complete without this
package { 'build-essential' :
    ensure => installed
}


class quickbox::apache {
    # Check https://github.com/puppetlabs/puppetlabs-apache for moar options

    # This is needed if you wan't to use php under debian & derivatives, replace with include ::apache when using centos or red hat.
    # While we're at it, also skip the default puppetlabs vhost.
    class { '::apache':
        default_vhost => false,
        mpm_module => 'prefork'
    }

    apache::vhost { 'quickbox.test':
        port => 80,
        docroot => '/vagrant/web',
        manage_docroot => false,
        options => ["FollowSymLinks"],
        override => ["FileInfo"]    # FileInfo enables mod rewrite from .htaccess files
    }
}

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

class quickbox::mysql {
    # Check https://github.com/puppetlabs/puppetlabs-mysql for moar options

    class { '::mysql::server' :
        override_options => {
            'mysqld' => {
                'bind-address' => '33.33.33.99'     # By listening on the external port, you can also connect from your host
            }
        }
    }

    mysql_user { 'quickbox@localhost':
        ensure => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour => '0',
        max_updates_per_hour => '0',
        max_user_connections => '0'
    }

    mysql_user { 'quickbox@33.33.33.1' :
        ensure => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour => '0',
        max_updates_per_hour => '0',
        max_user_connections => '0'
    }

    mysql_grant { 'quickbox@localhost/*.*' :
        ensure => 'present',
        options => ['GRANT'],
        privileges => ['ALL'],
        table => '*.*',
        user => 'quickbox@localhost',
        require => Mysql_user['quickbox@localhost']
    }

    mysql_grant { 'quickbox@33.33.33.1/*.*' :
        ensure => 'present',
        options => ['GRANT'],
        privileges => ['ALL'],
        table => '*.*',
        user => 'quickbox@33.33.33.1',
        require => Mysql_user['quickbox@33.33.33.1']
    }
}
