class cloudfoundry {

  include cloudfoundry::params
  require cloudfoundry::nodejs

  user { $cloudfoundry::params::user:
      ensure => present,
      managehome => true,
  }

  package { $cloudfoundry::params::packages:
      ensure => installed,
  }

  exec { "install rvm":
      command => 'bash -c \'bash <(/usr/bin/curl -s https://rvm.beginrescueend.com/install/rvm)\'',
      creates => "/usr/local/rvm",
      cwd => "/home/$cloudfoundry::params::user",
      path => "/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
      require => [ Package[$cloudfoundry::params::packages], User[$cloudfoundry::params::user] ]
  }

  rvm_system_ruby { "ruby-1.9.2-p180":
    default_use => true,
    provider => rvm_system_ruby,
    require => Exec["install rvm"],  
  }

  Rvm_gem {
      ruby_version => "1.9.2-p180",
      provider => rvm__gem,
  }

  rvm_gem { "bundler":
       ensure => "1.0.10",
       provider => rvm_gem,
       require => [ Package[$cloudfoundry::params::packages], Rvm_system_ruby["ruby-1.9.2-p180"] ],
  }

  rvm_gem { $cloudfoundry::params::gems:
       provider => rvm_gem,
       require => [ Package[$cloudfoundry::params::packages], Rvm_system_ruby["ruby-1.9.2-p180"] ],
  }

  exec { "create vcap repo":
      command => "/usr/bin/git clone https://github.com/cloudfoundry/vcap.git",
      creates => "/home/$cloudfoundry::params::user/vcap",
      cwd => "/home/$cloudfoundry::params::user",
      timeout => 0,
      require => [ User[$cloudfoundry::params::user], Package[$cloudfoundry::params::packages] ],
  }

  exec { "install vcap submodules":
      command => "/usr/bin/git submodule update --init",
      creates => "/home/$cloudfoundry::params::user/vcap/services/mysql/config",
      cwd => "/home/$cloudfoundry::params::user/vcap",
      timeout => 0,
      require => Exec["create vcap repo"],
  }

  define bundle { 

    exec { $name:
      command => "bundle install",
      cwd => "/home/$cloudfoundry::params::user/vcap/$name",
      timeout => 0,
      logoutput => true,
      path => "/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
      require => [ Exec["install vcap submodules"], Rvm_gem["bundler"], Rvm_gem[$cloudfoundry::params::gems] ],
    }
  }

  bundle { [ $cloudfoundry::params::components ] : }

  $mysql_password = $cloudfoundry::params::mysql_password
  file { "/home/$cloudfoundry::params::user/vcap/services/mysql/config/mysql_node.yml":
      ensure => present,
      content => template("cloudfoundry/mysql_node.yml.erb"),
      require => Exec["install vcap submodules"],
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

  file { [ "/var/vcap/sys/log", "/var/vcap/sys/run" ]:
      ensure => directory,
      owner => $cloudfoundry::params::user,
      require => File["/var/vcap/sys"],
  }

  file { "/tmp/vcap-run/":
      ensure => directory,
      owner => $cloudfoundry::params::user,
      mode => 0777,
  }

  # Manage nginx
  file { "/etc/nginx/nginx.conf":
      ensure => present,
      content => template("cloudfoundry/nginx.conf.erb"),
      owner => "root",
      group => "root",
      mode => 0400,
      notify => Service["nginx"],
      require => Package[$cloudfoundry::params::packages],
  }

  service { "nginx":
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => Package[$cloudfoundry::params::packages],
  }
}
