Puppet::Type.type(:rvm_system_ruby).provide :dummy_issue2384 do
    desc "Dummy provider for rvm_system_ruby.

    Fake nil resources when there is no rvm binary available. Allows
    puppetd to run on a bootstrapped machine before an rvm package has been
    installed. Workaround for: http://projects.puppetlabs.com/issues/2384
    "

    def self.instances
        []
    end
end
