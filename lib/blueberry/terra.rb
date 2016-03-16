require 'fileutils'
require 'erb'
require 'yaml'
require_relative './logger'
include Logging


class Terraform

  attr_accessor :role, :hostname
  def initialize(role, hostname)
     @role     = role
     @hostname = hostname
     @relative_path = File.expand_path(File.dirname(__FILE__))

     information_generator()
     generate_template()
  end

  # Required for letting ERB know of the existence of variables.
  def get_binding
    binding
  end

  # Parses and assigns variables from config.yaml
  def information_generator()
      # We need the config.yaml file. Load it in.
      File.exist?(@relative_path + '/config.yaml') ?
        config = YAML.load_file(@relative_path + '/config.yaml') :
        logger.fatal("Could not locate config file: #{config}") && abort

      # Do the variable jig.
      @access_key      = config['keys']['access']
      @secret_key      = config['keys']['secret']
      @def_region      = config['region']
  end

  # This method determines what role was provided by
  # user input and which template should be used.
  def determine_role()
    templates = []
    Dir.foreach(File.join(@relative_path, '..', 'blueberry', 'templates')) do |item|
      next if item == '.' or item == '..'
      templates << item.gsub(".erb", '').downcase # + "\n"
    end
    templates.join

    template_folder = "/templates/"
    if templates.include?(@role.downcase)
      template_path = File.join(@relative_path, template_folder, @role + '.erb')
    else
      logger.fatal "Unable to find role: #{@role}. Try options --list to verify it exists."
      abort
    end
  end

  # Update variables in provided template.
  def generate_template()

    file_name = @hostname + '.tf'
    check_file_exists(file_name)
    template_path = determine_role()

    template = File.read(template_path)
    renderer = ERB.new(template, nil, '-')
    open(file_name, 'w') { |f|
    	f.puts renderer.result(self.get_binding)
      f.close
    }

  end

  # Check if a provided file_name exists. If not, create. If yes, abort.
  def check_file_exists(file_name)
  	if File.exist?(file_name)
      logger.fatal "#{file_name} already exists."
  		abort
  	end
  end

  # Runs terraform plan to validate the manifest.
  def deploy_instance(path)
    Dir.chdir(path){
      %x[#{'terraform plan'}]
    }
  end

end # End Terraform
