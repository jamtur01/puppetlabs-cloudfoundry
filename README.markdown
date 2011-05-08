CloudFoundry Module
===================

This is the Puppet Labs CloudFoundry module.

It installs CloudFoundry VCAP on a host including all required packages and dependencies.

The installation may be lengthly given several components (NodeJS particularly) of the 
module require compilation.

The module is made up of three classes:

* cloudfoundry - the core class containined in init.pp
* cloudfoundry::nodejs - installs NodeJS
* cloudfoundry::bundle - contains the bundle definition that bundles gems
* cloudfoundry::params - contains the control parameters for the modules 

In the cloudfoundry::params class you can set the user, group you want to use CloudFoundry 
and password for your MySQL instance.

Usage
-----

    node "node.example.com" {
      include cloudfoundry
    }

Supported Platforms
-------------------

The module currently supports Debian, Ubuntu, Red Hat, CentOS, and Fedora.

License
-------

See LICENSE file.

Author
------

James Turnbull <james@lovedthanlost.net>

Credits
-------

All credit to Brandon Turner (https://github.com/blt04/puppet-rvm.git) for his rvm_gem type and provider.
