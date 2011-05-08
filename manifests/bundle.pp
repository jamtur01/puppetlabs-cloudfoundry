# Class: cloudfoundry::bundle
#
#   James Turnbull <james@lovedthanlost.net>
#   Status: This definition bundles Gems for CloudFoundry VCAP.
#
# Parameters:
#
#   $cloudfoundry::params::user:
#       User to run CloudFoundry
#
# Actions:
#   Bundles required VCAP gems
#
# Requires:
#
# Sample Usage:
#
#   cloudfoundry::bundle { "path/to/bundler/Gemfile": }
#
define cloudfoundry::bundle {

    include cloudfoundry::params

    exec { $name:
      command => "/tmp/bundle_install.sh",
      cwd => "/home/$cloudfoundry::params::user/vcap/$name",
      timeout => 0,
      logoutput => true,
      path => "/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
      require => [ File["/tmp/bundle_install.sh"], Exec["install vcap submodules"] ],
    }
}
