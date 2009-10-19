#
Given /^I have cubetext source (.*)$/ do |source|
  @source = source.escape
end

Given /^I have cubetext config (.*)$/ do |config|
  @config = CubeText.test_config( config ) unless config.to_s.empty?
end

Then /^cubetext result should be (.*)$/ do |result|
  @cubetext = CubeText.new
  @cubetext.config_roles( @config || {} )
  @cubetext.parse( @source )

  assert_equal( result.escape, @cubetext.to_html )
end


