require 'ream/template'

Given /^I have a string (.*)$/ do |string|
  @string = string
end

When /^I try to detect if string is a template placeholder$/ do
  @result = Ream::Template::RE.expand_includes === @string
  @name = @string[ Ream::Template::RE.expand_includes, 1 ]
end

When /^I try to detect if string is a template parameter placeholder$/ do
  @result = Ream::Template::RE.expand_params === @string
  @name = @string[ Ream::Template::RE.expand_params, 1 ]
end

Then /^parsing result should be (true|false)$/ do |result|
  assert_equal( result == "true", @result )
end

Then /^result name should be (.*)$/ do |string|
  assert_equal(
    string,
    @name
  )
end
