# puppet-docker
Puppet module to manage docker server

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
