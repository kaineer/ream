Given /^I have a source:$/ do |table|
  @source = table.raw.flatten
end

When /^scanner scans a source$/ do
  scanner = Ream::Template::Scanner.new
  @template = scanner.scan( @source )
end

Then /^scanner content with name (.*) should be (.*)$/ do |name, value|
  assert_equal( value, @template[ name ] )
end
