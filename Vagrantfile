# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # v2 configs...
  config.vm.box = 'ubuntu_wily-x64'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/wily/current/wily-server-cloudimg-amd64-vagrant-disk1.box'

  # Use :gui for showing a display for easy debugging of vagrant
  #config.vm.boot_mode = :gui

  config.vm.define :quickbox do |quickbox_config|
    quickbox_config.vm.host_name = "quickbox.test"

    config.vm.synced_folder ".", "/vagrant", type: "nfs"
#   config.vm.network "forwarded_port", guest: 8083, host: 8083


    config.vm.provider "virtualbox" do |vb|
        vb.customize [ 'modifyvm', :id, '--chipset', 'ich9' # solves kernel panic issue on some host machines
        ]
        vb.customize [ 'modifyvm', :id, '--nic1', 'nat'
        ]
        vb.customize [ 'modifyvm', :id, '--nic2', 'hostonly'
        ]
        vb.customize [ 'modifyvm', :id, '--hostonlyadapter2', 'vboxnet0'
        ]
    end

    # If you change the private ip and want to access mysql from the outside as well,
    # also update the mysql config in quickbox.pp
    config.vm.network :private_network, ip: "33.33.33.99"

    # Pass installation procedure over to Puppet (see `support/puppet/manifests/cruisetravel.pp`)
    config.vm.provision :puppet do |puppet|
      puppet.module_path = "support/puppet/modules"
      puppet.manifests_path = "support/puppet/manifests"
      puppet.manifest_file = "quickbox.pp"
      puppet.working_directory = "/vagrant/" + puppet.manifests_path
      puppet.options = [
        '--verbose',
        #'--debug',
      ]
    end
  end
end
