#!/usr/bin/env ruby
#
# Usage: ./deploy -n dev-1.forgenet.us -r gameserver
#

require_relative './blueberry/terra'
require_relative './blueberry/user_input'
require_relative './logger'
include Logging

begin
  [ 'trollop' ].each(&method(:require))
rescue LoadError => e
  logger.fatal("You are missing required gem: " + e.message.split[-1]) && abort
end

# Get user CLI input.
options = UserInput.parse(ARGV)

# Create Terraform manifest from template.
instance = Terraform.new(options[:role],
                         options[:hostname],
                         )
