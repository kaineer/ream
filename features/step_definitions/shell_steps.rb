require 'ream/shell'

Given /^I have an abstract shell with mock executor$/ do
  @executor = mock( "ShellExecutor" )
  @shell = Ream::Shell.new( @executor )
end

Then /^abstract shell does not leave loop$/ do
  assert( @shell.running? )
end

Then /^abstract shell (does not get|gets) exception$/ do |does_or_does_not|
  does = !does_or_does_not.include?( "does" )
  assert_equal( does, @shell.got_exception? )
end

Given /^mock shell executor expects (.*) command$/ do |cmd|
  @executor.expects( :apply ).with( cmd, [] ).returns( true )
end

Then /^abstract shell should take (.*) command successfully$/ do |cmd|
  @shell.apply( cmd )
end

Given /^shells command wants shell to leave$/ do
  @executor.expects( :apply ).returns( false )
end

Then /^abstract shell leaves loop$/ do
  @shell.apply( "anycommand" )
  assert( !@shell.running? )
end

Given /^mock executor throws exception on each command$/ do
  @executor.stubs( :apply ).raises( Exception )
end

Given /^I have an abstract shell with except throwing executor$/ do
  @shell = Ream::Shell.new( ShellFeature::ExceptionThrower.new )
end

Given /^I feed (.*) command to shell$/ do |cmd|
  @shell.apply( cmd )
end

Given /^mock shell executor expects (.*) command with args:$/ do |cmd, table|
  @executor.stubs( :apply ).with( cmd, table.raw.flatten ).returns( true )
end

Given /^mock shell executor expects (.*) command which wants shell to leave$/ do |cmd|
  @executor.expects( :apply ).with( cmd, [] ).returns( false )
end

Given /^abstract shell reads (.*)$/ do |cmd|
  @shell.expects( :read ).returns( cmd )
end

Given /^abstract shell reads:$/ do |table|
  expectation = @shell
  inputs = sequence( 'inputs' )
  table.raw.flatten.each_with_index do |cmd, i|
    expectation.expects( :read ).returns( cmd ).in_sequence( inputs )
  end
end

When /^I run shell$/ do
  @shell.run
end

Then /^abstract shell is not running anymore$/ do
  assert( !@shell.running? )
end
