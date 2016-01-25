# Set path for all exec calls globally
Exec {
    path => ["/bin", "/bin/usr"]
}

# Uncomment to include apache, mysql, php etc etc
#include quickbox::apache
#include quickbox::php
#include quickbox::mysql
include quickbox::elasticsearch

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

# Install git in the guest, since every half-decent package manager needs it
package { 'git' :
    ensure => installed
}

# Install build essentials, because this box is created for experimental software so it wouldn't be complete without this ;)
package { 'build-essential' :
    ensure => installed
}
