require 'ream/template/replacer'

Given /^I have template replacer with items:/ do |table|
  items = {}
  table.hashes.each do |hash|
    items[ hash[ 'name' ] ] = hash[ 'value' ]
  end
  @replacer = Ream::Template::Replacer.new( items )
end

Given /^I have template items$/ do
  @items = {}
end

Given /^they contain template (.*) with value (.*)$/ do |name, value|
  @items[ name ] = value
end

Given /^I place them into replacer$/ do
  @replacer = Ream::Template::Replacer.new( @items )
end

Given /^I have template items:$/ do |table|
  @items = {}
  table.hashes.each do |hash|
    @items[ hash[ 'name' ] ] = hash[ 'value' ]
  end
end

Then /^replacing template (.*) I will get value (.*)$/ do |name, value|
  assert_equal( value, @replacer[ name ] )
end

Then /^expanding template (.*) I will get value (.*) with params:$/ do |name, value, table|
  params = {}
  table.hashes.each { |hash|
    params[ hash[ 'name' ] ] = hash[ 'value' ]
  }

  assert_equal( value, @replacer[ name, params ] )
end
