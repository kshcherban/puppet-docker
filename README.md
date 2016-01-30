# puppet-docker
Puppet module to manage docker server.  
It installs docker package, manages /etc/default/docker, can setup nginx proxy and configure accesses to it.  
Depends on puppetlabs/apt, tested on Ubuntu 14.04  


Example setup that includes nginx proxy with basic auth.

```puppet
class {'docker':
    nginx_proxy      => true,
    nginx_proxy_auth => true,
    nginx_proxy_user => 'docker',
    nginx_proxy_pass => 'mysecretpass',
    nginx_proxy_port => '4243',
}
```
