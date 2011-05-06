

class cloudfoundry::params {

    $cloudfoundry::params::user           = 'cloudfoundry'
    $cloudfoundry::params::group          = 'cloudfoundry'
    $cloudfoundry::params::mysql_password = 'password'

    case $operatingsystem {
      debian, ubuntu: {
        $cloudfoundry::params::packages = [ "autoconf", "curl", "git-core", "ruby", "bison", "build-essential",
                                            "zlib1g-dev", "libreadline5-dev", "nginx", "libreadline5-dev", "erlang",
                                            "libxml2", "libxml2-dev", "libxslt1.1", "libxslt1-dev", "git-core", "sqlite3",
                                            "libsqlite3-ruby", "libsqlite3-dev", "unzip", "zip", "rake", "ruby-dev", "libmysql-ruby",
                                            "libmysqlclient-dev", "libpq-dev", "postgresql-client", "lsof", "psmisc",
                                            "librmagick-ruby", "python-software-properties", "java-common", "openjdk-6-jre" ]
        $cloudfoundry::params::nodejs_packages = [ "python", "python-software-properties", "libssl-dev" ]
      }
      redhat, fedora, centos: {
        $cloudfoundry::params::packages = [ ]
      }
      default: { }
    }
}
