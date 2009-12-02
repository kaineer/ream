# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/ream.rb'

require 'cucumber/rake/task'

<<<<<<< HEAD:rakefile
$:.unshift( "lib" )
=======

Hoe.new('ream', Ream::VERSION) do |p|
 p.developer('kaineer', 'kaineer@gmail.com')
end
>>>>>>> d3190d5be9ffb6ff7a3a25d73870e4f3543c73a5:Rakefile

Cucumber::Rake::Task.new( "features" ) do |t|
  t.cucumber_opts ||= ""
  if ENV[ "CUCUMBER_TAGS" ]
    tags = ENV[ "CUCUMBER_TAGS" ]
    tag_array = tags.split( 32.chr )
    t.cucumber_opts = tag_array.map{|s|"--tags #{s}"} * 32.chr
  end
  t.cucumber_opts << " #{ENV[ "CUCUMBER_OPTS" ]}" if ENV[ "CUCUMBER_OPTS" ]
end

task :default => :features

# vim: syntax=Ruby
