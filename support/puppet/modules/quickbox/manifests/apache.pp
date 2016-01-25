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
