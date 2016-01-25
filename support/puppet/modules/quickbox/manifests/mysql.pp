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
