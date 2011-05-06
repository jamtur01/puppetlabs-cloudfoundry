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
        cwd => "/home/$cloudfoundry::params::user",
        creates => "/usr/local/bin/node",
    }
}
