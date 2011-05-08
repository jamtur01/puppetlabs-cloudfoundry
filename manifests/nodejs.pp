# Class: cloudfoundry::nodejs
#   James Turnbull <james@lovedthanlost.net>
#   Status: This class is working and installs NodeJS for CloudFoundry VCAP. 
# 
#   This class models NodeJS installation in Puppet
#
# Parameters: 
#   $cloudfoundry::params::nodejs_packages:
#       NodeJS pre-req packages
# 
# Actions:
#   Installs prereq packages
#   Downloads and builds NodeJS
# 
# Requires:
# 
# Sample Usage: 
#   include cloudfoundry::nodejs
#
class cloudfoundry::nodejs {

    include cloudfoundry::params

    package { $cloudfoundry::params::nodejs_packages:
        ensure => installed,
    }

    exec { "install nodejs":
        command => "wget http://nodejs.org/dist/node-latest.tar.gz && \
                tar zxf node-latest.tar.gz && \
                cd node-v* && \
                ./configure && \
                make && \
                make install",
        path => "/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
        cwd => "/tmp",
        creates => "/usr/local/bin/node",
        timeout => 0,
        require => Package[$cloudfoundry::params::nodejs_packages],
    }
}
