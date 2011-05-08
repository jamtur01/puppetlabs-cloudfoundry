# Class: cloudfoundry::params
#   James Turnbull <james@lovedthanlost.net>
#   Status: This class contains required parameters for installing CloudFoundry VCAP
#
# Parameters:
#
# Actions:
#   Sets global parameters
#   Sets platform specific parameters
#
# Requires:
#
# Sample Usage:
#   include cloudfoundry::params
#
class cloudfoundry::params {

    $user           = 'cloudfoundry'
    $mysql_password = 'password'
    $components     = [ "cloud_controller", "dea", "router", "services/redis", "services/mysql",
                        "services/mongodb" ]
    $gems           = [ "vmc", "rake", "builder" ]

    case $operatingsystem {
      debian, ubuntu: {
        $packages = [ "autoconf", "curl", "git-core", "ruby", "bison", "build-essential",
                      "zlib1g-dev", "nginx", "libreadline5-dev", "erlang",
                      "libxml2", "libxml2-dev", "libxslt1.1", "libxslt1-dev", "sqlite3",
                      "libsqlite3-ruby", "libsqlite3-dev", "unzip", "zip", "ruby-dev", "libmysql-ruby",
                      "libmysqlclient-dev", "libpq-dev", "postgresql-client", "lsof", "psmisc",
                      "librmagick-ruby", "java-common", "openjdk-6-jre", "rake" ]
        $nodejs_packages = [ "python", "python-software-properties", "libssl-dev" ]

        exec { "apt-get update":
          path => "/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
        }
      }
      redhat, fedora, centos: {
        
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL": 
          owner => root, 
          group => root, 
          mode => 0444, 
          source => "puppet:///cloudfoundry/rpm-gpg/RPM-GPG-KEY-EPEL" 
        }
        
        yumrepo { "epel": 
          mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch', 
          enabled => 1, 
          gpgcheck => 1, 
          gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL", 
          require => File["/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL"] 
        }

        $packages = [ "ruby-devel", "ruby-­docs", "ruby-ri", "rubygems", "ruby-rdoc", "ruby-rake", 
                      "erlang", "autoconf", "curl", "git", "bison", "gcc", "gcc-c++", "kernel-devel",
                      "nginx", "lsof", "psmisc", "rubygem-rake", "libxslt", "libxslt-devel", "libxml2",
                      "libxml2-devel", "readline-devel", "make", "mysql-client", "mysql-devel", "zlib-devel",
                      "sqlite3", "sqlite3-devel", "sqlite3-ruby", "unzip", "zip", "ruby-mysql",  "postgresql", 
                      "postgresql-devel", "imagemagick", "librmagick-ruby", "libmagickwand-dev", "java-1.6.0-openjdk", ]
        $nodejs_packages = [ "python", "openssl-dev" ]
      }
      default: { }
    }
}
