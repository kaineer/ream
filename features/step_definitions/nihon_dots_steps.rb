require 'ream/nihon/dots'

Given /^nihon syntax string "(.*)"$/ do |string|
  @dots = Ream::Nihon::Dots.new( string.escape )
end

Given /^nihon syntax tested with "(.*)"$/ do |string|
  @dot_result = Ream::Nihon::Dots.try( string.escape )
end

Then /^nihon syntax string inspect should be (.*)$/ do |result|
  assert_equal( result.escape, @dots.inspect )
end

Then /^nihon syntax string should display as "(.*)"$/ do |result|
  assert_equal( result, @dots.to_s )
end

Then /^nihon syntax success is (false|true)$/ do |success|
  assert_equal( success == "true", @dot_result.ok? )
end

Then /^ninon syntax unparsed is (.*)$/ do |unparsed|
  assert_equal( unparsed, @dot_result.rest )
end
