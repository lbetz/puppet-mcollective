#puppet-mcollective

##Overview
Puppet module to manage MCollective server, client and user. Only SSL certifikate authentication is supported, yet. Also supports activemq only. But has to be expanded easily for other message queues like rabbitmq, just a few lines in some config files have to change.
##Module Description

###Compatibility
This module uses packages from puppetlabs and runs on RHEL/Centos and Debian. Actually it's testet on Debian 6 and CentOS 6.

###Requirements
  - Puppet 3.x
  - puppetlabs/stdlib >= 3.2.2

You must run puppet in agent mode and certicicates have to be found in /var/lib/puppet/ssl.

##Setup

##Usage

###Beginning with MCollective Server
Requires a puppet setup with a master and stored configs enabled. An installed ActiveMQ using SSL certificates. User certificates can used from puppet CA, created by 'puppet cert generate'.

First we wanna install a server connecting to an activemq on host master using the default port. The argument 'agents' put the packages for the given agents on the host. The private key and the signed certificate here is set as string in base64.
```class { 'mcollective::server':
  agents => ['package', 'puppet', 'service', 'nettest', 'nrpe'],
  mqueue => {
    host     => 'master',
    password => 'gruelfin',
  },
  key    => '-----BEGIN RSA PRIVATE KEY-----
MIIJK....
-----END RSA PRIVATE KEY-----',
  cert   => ''-----BEGIN CERTIFICATE-----
MIIFX...
-----END CERTIFICATE-----',
}```

If you wanna use keys and certificates are stored in files leave arguments key and cert out.
```class profiles::base {
  class { 'mcollective::server':
    mqueue => {
      host     => 'master',
      password => 'gruelfin',
    },
  }
}
```
The files for key end certificate then must saved in files/private_keys and files/certs repectively of the calling module like a profiles class. Both files have to be named mcollecive-servers.pem.
```modules
|-- mcollective
`-- profiles
  `-- files
    |-- private_keys
    |  `-- mcollective-servers.pem
    ´-- certs
      `-- mcollective-servers.pem
```

###Installing a client including an user
Now we're installing the client package and additionally the packages for the client base usage of the puppet, packages, service, nettest and nrpe services. And we use the root account on this host to connect the message queue on 'master'. The necessary configuration file '.mcollective', the client key and certificate ('.mcollective.d') are stored in the given home directory '/root'. The client key and certificate are named 'foo.pem'.
```class { 'mcollective::client':
  plugins => ['puppet', 'packages', 'services', 'nettest', 'nrpe'],
}

mcollective::client::user { 'foo':
  user   => 'root',
  owner  => 'root',
  home   => '/root',
  mqueue => {
    host     => 'master',
    password => 'gruelfin',
  },
}
```
Here we used for the key and the certivicates, client and mcollective-servers certs, files like above in the server configuration. That means both declarations are contained by another class, i.e. profiles, the mcollective module takes it outta this profiles module's files directory.
 
```modules
|-- mcollective
`-- profiles
  `-- files
    |-- private_keys
    |  `-- foo.pem
    ´-- certs
      |-- foo.pem
      `-- mcollective-servers.pem
```

###Classes and Defined Types

####Class: mcollective::server
**Parameters within `tomcat`:**

#####ensure
present or running (present), stopped

#####enable
Enables (true, default) or disables (false) the service to start at boot.

#####agents
List (array) of agents have to be installed.

#####key
Private session key to use. Default is a base coded file, source gets from ${caller_module_name}/private_keys/mcollective-servers.pem on the puppetmaster.

#####cert
Session certificate to use. Default is a base coded file, source gets from ${caller_module_name}/certs/mcollective-servers.pem on the puppetmaster

#####mqueue
Parameters hash for MQ connection. Defaults are:
  host     => 'puppet',
  port     => '61614',
  user     => 'mcollective',
  password => 'marionette',


#####Class: mcollective::client

#####plugins
List (array) of plugins have to be installed. Defaults are 'package', 'puppet' andf 'service'.


####Define Type: mcollective::server::agent

#####ensure
Installs agent (present) or removes (absent). Default is present.

#####agent
Sets the agent name, default is the title.

#####package
Use this package name for installation. Default: mcollective-${agent}-agent


####Define Type: mcollective::client::plugin

#####ensure
Installs plugin (present) or removes (absent). Default is present.

#####plugin
Sets the plugin name, default is the title.

#####package
Use this package name for installation. Default: mcollective-${plugin}-client


####Define Type: mcollective::client::user

#####certname
Name of the certificate file, the suffix .pem is automatically added. Default is the 'title' of the define resource.

#####user
User to use and the owner of all files. Default is the 'title'.

#####group
Group to use and the group of all files. Default is the 'title'.

#####home
The home directory of the chosen user. Default ist the '/home/title'.

#####server_cert
The mcolelctive session certificate. By default a file mcollective-servers.pem is taken from the puppetmaster out of ${caller_module_name}/certs/.

#####key
Private key of the user, base64 coded. By default a file user.pem is taken from the puppetmaster out of ${caller_module_name}/certs/.

#####cert
User certificate, base64 coded. By default a file user.pem is taken from the puppetmaster out of ${caller_module_name}/private_keys/.

#####mqueue
Parameters hash for MQ connection. Defaults are:
  host     => 'puppet',
  port     => '61614',
  user     => 'mcollective',
  password => 'marionette',
