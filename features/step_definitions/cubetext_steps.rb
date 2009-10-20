#
Given /^I have cubetext parser$/ do
  @cubetext = CubeText.new
end

Given /^I have cubetext config (.*)$/ do |config|
  @config = CubeText.test_config( config ) unless config.to_s.empty?
  @cubetext.config_roles( @config || {} )
end

Given /^I set cubetext parser to xml mode$/ do
  @cubetext.xml!
end

Given /^I set cubetext parser to unquote mode$/ do
  @cubetext.unquote!
end

Given /^I have no cubetext config$/ do
  @cubetext.config_roles( {} )
end

#
When /^I feed cubetext source (.*)$/ do |source|
  @cubetext.parse( source.escape )
end

Then /^cubetext result should be (.*)$/ do |result|
  assert_equal( result.escape, @cubetext.to_html )
end

