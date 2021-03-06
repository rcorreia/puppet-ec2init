class ec2init::ddns {
    include ::ec2init::params

    if $::ec2init::params::hostname and $::ec2init::params::aws_key and $::ec2init::params::aws_secret and $::ec2_public_hostname {
        package {
            'python-boto':
                ensure  => present;
            'ec2ddns':
                ensure  => present,
                require => Package['python-boto'];
        }
        exec { 'register dynamic dns hostname':
            command => "/usr/bin/python /usr/sbin/ec2ddns.py -k ${::ec2init::params::aws_key} -s ${::ec2init::params::aws_secret} ${::ec2init::params::hostname} ${::ec2_public_hostname}",
            require => Package['ec2ddns'],
        }
    }
}
