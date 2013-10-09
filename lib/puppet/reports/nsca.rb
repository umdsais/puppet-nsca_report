require 'puppet'
require 'yaml'

Puppet::Reports.register_report(:nsca) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), 'nsca.yaml'])
  raise(Puppet::ParseError, "Configfile for NSCA report #{configfile} does not exist") unless File.exist?(configfile)

  config = YAML.load_file(configfile)

  NSCA_BINARY = config[:nsca_binary]
  NSCA_CONFIG = config[:nsca_config]
  NSCA_HOST = config[:nsca_host]
  NSCA_PORT = config[:nsca_port]
  SERVICE_DESC = config[:service_desc]
  STRIP_DOMAIN = config[:strip_domain]
  ONLY_ENV = config[:only_env]
  
  desc <<-DESC
  Send puppet reports to Nagios/Icinga using NSCA.
  DESC

  def process
    if self.kind == 'apply'
      if ONLY_ENV == self.environment
        if STRIP_DOMAIN == true
          client = self.host.split('.').first
        else
          client = self.host
        end
  
        Puppet.debug "NSCA Report: Processing report for #{client}"
        perfdata = ''
  
        if self.status == 'failed'
          # get number of failed resources and create service output
          return_code = 1
  	fail_count = self.metrics['resources']['failed']
  	output = "WARNING: Puppet run has #{fail_count} failed resource(s)"
        else
          return_code = 0
  	output = "OK: Puppet run completed successfully"
        end
  
        # send all time and resource metrics as nagios perfdata
        self.metrics.each { |metric,data|
          data.values.each { |val|
            if metric == 'time'
  	    perfdata = perfdata.concat(val[0]).concat("=").concat(val[2].to_s).concat("s;;;; ")
  	  elsif metric == 'resources'
  	    perfdata = perfdata.concat(val[0]).concat("=").concat(val[2].to_s).concat(";;;; ")
    	  end
          }
        }
      end
    end
    
    # format: <host_name>[tab]<svc_description>[tab]<return_code>[tab]<plugin_output>[newline]
    message = "#{client}\t#{SERVICE_DESC}\t#{return_code}\t#{output}|#{perfdata}\n"

    system("echo \"#{message}\" | #{NSCA_BINARY} -H #{NSCA_HOST} -c #{NSCA_CONFIG} -p #{NSCA_PORT}")
  end
end
