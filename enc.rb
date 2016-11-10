#!/usr/bin/env ruby
#
require 'yaml'

env = `mdata-get environment`.strip || 'unknown'

p = { environment: env }

puts p.to_yaml.to_s

