require 'ream/nihon/romaji_parser'

Given /^romaji parser parses (.*)$/ do |romaji|
  @result = Ream::Nihon::RomajiParser.parse( romaji )
end

Then /^romaji parser returns (.*)$/ do |result|
  assert_equal( result, @result.arr * 32.chr )
end

Then /^romaji parser can not parse (.*)$/ do |rest|
  assert_equal( rest, @result.str )
end

Then /^romaji parser failure is (true|false)$/ do |failure|
  assert_equal( failure == "true", @result.failure? )
end
