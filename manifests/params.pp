# Class nsca_report::params.pp
# Set default parameters
class nsca_report::params {
  case $::osfamily {
    'Windows' : {
      # Windows prefixes normal paths with the Data Directory's path and leaves 'puppet' off the end
      $dir_prefix = 'C:/ProgramData/PuppetLabs/puppet'
      $dir        = "${dir_prefix}/etc"
    }
    /^(FreeBSD|DragonFly)$/ : {
      $dir = '/usr/local/etc/puppet'
    }
    'Archlinux' : {
      $dir= '/etc/puppetlabs/puppet'
    }
    'Redhat' : {
      $dir= '/etc/puppetlabs/puppet'
    }
    default : {
      $dir  = '/etc/puppet'
    }
  }
}

