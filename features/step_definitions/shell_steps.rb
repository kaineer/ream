require 'ream/shell'

Given /^I have an abstract shell$/ do
  @executor = mock()
  @shell = Ream::Shell.new
end

Given /^I feed (.*) command to shell$/ do |cmd|
  @shell.apply( cmd )
end

Then /^a shell should try to execute (.*) command$/ do |cmd|
  @executor.expects( :apply ).with( cmd )
end
