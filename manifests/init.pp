class cloudfoundry {

  include cloudfoundry::params
  require cloudfoundry::nodejs

  # Create Cloudfoundry user and group
  user { $cloudfoundry::params::user:
      ensure => present,
      managehome => true,
  }

  group { $cloudfoundry::params::group:
      ensure => present,
  }

  # Install required packages
  package { $cloudfoundry::params::packages:
      ensure => installed,
  }

  # Install rvm
  exec { "install rvm":
      command => "bash < <(curl -s -k -B https://rvm.beginrescueend.com/install/rvm)",
      creates => "/usr/local/bin/rvm",
      cwd => "/home/$cloudfoundry::params::user",
  }

  package { [ "vmc", "mysql", "pg", "tilt", "daemons", "bundler", "rack", "rake", "thin", "sinatra", "eventmachine" ]:
      ensure => latest,
      provider => "gem",
  }

  exec { "create vcap repo":
      command => "git clone https://github.com/cloudfoundry/vcap.git",
      creates => "/home/$cloudfoundry::params::user/vcap",
      cwd => "/home/$cloudfoundry::params::user",
      require => Package[$cloudfoundry::params::packages],
  }

  exec { "install vcap submodules":
      command => "git submodule update --init"
      creates => "/home/$cloudfoundry::params::user/vcap/tests",
      cwd => "/home/$cloudfoundry::params::user/vcap",
      require => exec["create vcap repo"],
  }

  exec { "set mysql password":
      command => "sed -i.bkup -e \'s/pass: root/pass: $cloudfoundry::params::mysql_password/\' mysql_node.yml",
      cwd => "/home/$cloudfoundry::params::user/vcap/services/mysql/config",
      require => [ User["$cloudfoundry::params::user"], exec["install vcap submodule"] ],
  }

  # Install VCAP directories
  file { [ "/var/vcap", "/var/vcap.local" ]:
      ensure => directory,
      owner => $cloudfoundry::params::user,
  }

  file { [ "/var/vcap/services", "/var/vcap/shared", "/var/vcap/sys", "/var/vcap/runtimes" ]:
      ensure => directory,
      owner => $cloudfoundry::params::user,
      require => File["/var/vcap"],
  }

  file { "/var/vcap/sys/log":
      ensure => directory,
      owner => $cloudfoundry::params::user,
      require => File["/var/vcap/sys"],
  }

  # Manage nginx
  file { "/etc/nginx/nginx.conf":
      ensure => present,
      content => template("nginx.conf.erb"),
      owner => "root",
      group => "root",
      mode => 0400,
      notify => Service["nginx"],
      require => Package[$cloudfoundry::params::packages],
  }

  service { "nginx":
      ensure => running,
      enabled => true,
      require => Package[$cloudfoundry::params::packages],
  }
