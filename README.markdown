#puppet-nsca\_report

####Table of Contents
1. [Overview](#overview)
2. [Setup](#setup)
    * [Nagios/Icinga](#nagios-icinga)
    * [Puppetmaster](#puppetmaster)


## Overview
The nsca\_report module ships a custom puppet report processor to process and send the results
of puppet agent runs to a Nagios/Icinga monitoring server.

## Setup

### Nagios/Icinga
On the Nagios/Icinga side configure a passive service check for each puppet client:

```nagios
define service{
        use                             linux-service
        hostgroup_name                  linux
        service_description             NRPE_puppet_status
        check_command                   check_nrpe!check_filetime.py\!/var/lib/puppet/state/state.yaml\!3h\!4h
        max_check_attempts              1
        freshness_threshold             6000
        active_checks_enabled           0
        check_freshness                 1
        }
```


### Puppetmaster
In order to process and send the Puppet agents results, enable report
processing in /etc/puppet/puppet.conf.

On each puppet client put
```
  report = true 
```

in /etc/puppet/puppet.conf

On the server-side put
```
  reports = nsca
  pluginsync = true
```
in /etc/puppet/puppet.conf


The NSCA report expects a configuration file with connection information
in /etc/puppet/nsca.yaml. Example:
```yaml
---
:nsca_binary: /usr/bin/send_nsca
:nsca_host: <HOSTNAME>
:nsca_config: /etc/nagios/send_nsca.cfg
:nsca_port: 5667
:service_desc: NRPE_puppet_status
:strip_domain: true
:only_env: production
```


