# == Class: nsca_report
#
# Report puppet runs to Nagios/Icinga using NSCA
#
# === Parameters
#
# [*dir*]
#   Directory where rest of puppet configuration is
#   Default: $::nsca_report::params::dir (osfamily dependent)
#
# [*nsca_binary*]
#   Path to nsca binary
#   Default: '/usr/sbin/send_nsca'
#
# [*nsca_config*]
#   Nsca configuration file
#   Default: '/etc/nagios/send_nsca.cfg'
#
# [*nsca_host*]
#   Address of nsca server
#   Default: 'nagios'
#
# [*nsca_port*]
#   Portnumber of nsca server
#   Default: 5667
#
# [*only_env*]
#   Only report for this puppet environment
#   Default: 'production'
#
# [*service_desc*]
#   Description of the nagios service
#   Default: 'puppet_status'
#
# [*strip_domain*]
#   Whether to strip the domain off the hostname before sending
#   Default: true
#
# === Examples
#
#  class { 'nsca_report':
#    nsca_host    => 'nagios01.example.com',
#  }
#
# === Authors
#
# Alexander Hoffman <alexander.hofmann@gmail.com>
#
class nsca_report(
  $dir          = $::nsca_report::params::dir,
  $nsca_binary  = '/usr/sbin/send_nsca',
  $nsca_config  = '/etc/nagios/send_nsca.cfg',
  $nsca_host    = 'nagios',
  $nsca_port    = 5667,
  $only_env     = 'production',
  $service_desc = 'puppet_status',
  $strip_domain = true,
)inherits nsca_report::params{

  file { "$dir/nsca.yaml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nsca_report/etc/puppet/nsca.yaml.erb'),
  }

}
