QuickBox
========
QuickBox is a simple vagrant / puppet config for a basic LAMP virtualbox.

It's main purpose is for when you need a quick throwaway virtual machine for prototyping and experimenting with new
technology. Setting up a clean VM everytime you want to try something new is not very complicated, but is is tedious and
it takes time I'd rather spend coding. QuickBox is not intended as a server setup or a real development environment.

The directory structure is one I'm personally used to. The webroot can be found web/ and the .htaccess rewrites
everything to index.php. You can find the quickbox manifest in support/puppet/manifests/quickbox.pp. You can configure
the webroot there if you prefer another setup.

**DO NOT USE THIS IN PRODUCTION** There are no firewalls configured, the mysql user has no password, etc etc. This
box is just to play around with and not secure in any way.

Installed software
------------------
 - Ubuntu 14.10
 - MySQL Server 5.5
 - PHP 5.5 (With php5-mysql and php5-curl)
 - Apache 2
 - Composer
 - PHPUnit
 - Git
 - Build essentials

If you don't want to use PHP, MySQL or Apache, just comment out the quickbox::[package] line in quickbox.pp.

If you don't want to use composer, then delete the composer.* files.

If you don't want to use PHPUnit remove composer.lock and remove phpunit from composer.json.

All of these are configured mostly with factory defaults, so you might want to tweak php.ini or my.cnf.

Quickbox.pp
-----------
Please take a look at quickbox.pp, it's pretty well commented.

A mysql user (username: quickbox, no password) will be created when you add mysql to the box. You should be able to
connect to mysql with this user from your host machine as well.

I'm a huge fan of using a lot of aliases in my dev environment and also having these aliases under version control.
Add your aliases to support/puppet/files and they will be available after provisioning and logging in.

Installation
------------
```
git clone git@github.com:fdeweger/quickbox.git
cd quickbox
git submodule update --init --recursive
vagrant up
```

You'll need to add the following line to your hosts file:
```
33.33.33.99 quickbox.test
```

If you open http://quickbox.test in your browser of choice, it should display a basic phpinfo page.

Known issues
------------
On some machines / installations you'll need to change the hostonly adapter in your Vagrantfile to vboxnet1.

This machine is currently only tested on an Ubuntu 14.04 host, using vagrant 1.4.3 and virtualbox 4.3.10. If you have
issues with an other OS or an other version of vagrant, feel free to open an issue on https://github.com/fdeweger/quickbox

License & Warranty
------------------
Feel free to do whatever you want with this software. It would be appreciated that you give me a mention if you use a
changed version of QuickBox. You can send pull requests or create issues on Github and I'll look into them.

This software comes without any form of warranty. It might work partially, it might explode, it might do nothing. You'll
be using this software on your own responsibility and I'm not accountable for any malfunction or damage from using
QuickBox. Use at your own risk.
