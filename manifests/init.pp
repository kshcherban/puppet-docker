class docker (
    $version              = 'present',
# where images and containers are stored
    $graph_dir            = '/var/lib/docker',
# custom dns server to use
    $dns_server           = undef,
# Daemon socket(s) to connect to, array
    $host                 = undef,
# Enable insecure registry communication
    $insecure_registry    = undef,
# Name of docker package
    $package_name         = 'docker-engine',
# Nginx proxy to expose api port outside
    $nginx_proxy          = false,
# Nginx proxy nginx package version
    $nginx_proxy_ver      = 'present',
# Nginx basic auth, off by default
    $nginx_proxy_auth     = false,
# Nginx allowed ip/subnets array
    $nginx_proxy_allowip  = undef,
# Nginx proxy basic auth user
    $nginx_proxy_user     = 'docker',
# Nginx proxy basic auth password
    $nginx_proxy_pass     = 'docker',
# Nginx proxy port
    $nginx_proxy_port     = 4243,
) {
    apt::source { 'docker':
        location => 'http://apt.dockerproject.org/repo',
        release  => 'ubuntu-trusty',
        repos    => 'main',
        key      => {
            'id'     => '58118E89F3A912897C070ADBF76221572C52609D',
            'server' => 'pgp.mit.edu',
        },
    }
    ->
    package {$package_name:
        ensure  => $version,
        require => Exec['apt_update'],
    }
    ->
    service {'docker':
        ensure => 'running',
    }
    file {'/etc/default/docker':
        ensure  => 'present',
        content => template('docker/default.docker.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        notify  => Service['docker'],
        require => Package[$package_name],
    }
    if $nginx_proxy {
        package {'nginx':
            ensure  => $nginx_proxy_ver,
            require => Service['docker'],
        }
        ->
# Changing www-data group needed to access socket
        user {'www-data':
            groups => ['docker'],
        }
        ->
        file {'/etc/nginx/.passwd':
            ensure  => 'present',
            content => template('docker/nginx.passwd.erb'),
        }
        ->
        file {'/etc/nginx/sites-enabled/docker.conf':
            ensure  => 'present',
            content => template('docker/nginx-proxy-docker.conf.erb'),
        }
        ~>
        service {'nginx':
            ensure => 'running',
        }
    }
}
