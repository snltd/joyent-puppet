#!/usr/bin/env ruby

require 'yaml'

require 'facter'
env  = `mdata-get environment`.strip || 'unknown'
role = `mdata-get role`.strip || 'unknown'

out = { environment:  env,
        classes:      %w[basenode telegraf] }

if role == 'sinatra'
  out[:classes] += %w[sinatra caddy filebeat]
elsif
  role == 'wavefront-proxy'
  out[:classes].<< 'wavefront_proxy'
end

puts out.to_yaml
