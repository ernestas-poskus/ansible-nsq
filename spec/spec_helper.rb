require 'serverspec'
set :backend, :exec
set :os, :family => 'redhat', :release => '7', :arch => 'x86_64'
