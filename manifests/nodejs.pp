class cloudfoundry::nodejs {

    include cloudfoundry::params

    package { $cloudfoundry::params::nodejs_packages:
        ensure => installed,
        require => Exec[$cloudfoundry::params::package_update],
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
