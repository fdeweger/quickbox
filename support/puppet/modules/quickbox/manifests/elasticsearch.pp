class quickbox::elasticsearch {
    class { '::elasticsearch':
      ensure => 'present'
    }
}
