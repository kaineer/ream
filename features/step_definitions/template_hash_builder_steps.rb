require 'ream/template/hash_builder'

Given /^I have a new hash builder$/ do
  @hash_builder = Ream::Template::HashBuilder.new
end

Given /^I added to hash builder a key (.*)$/ do |key|
  @hash_builder.open( key )
end

Given /^I added to hash builder a line (.*)$/ do |string|
  @hash_builder << string
end

Given /^I added to hash builder lines (.*)$/ do |lines|
  @lines = lines.split( ", " )
  @lines.each do |line|
    @hash_builder << line
  end
end

Given /^I closed hash builder's key$/ do #'
  @hash_builder.close!
end

Then /^key (.*) from hash builder does not exist$/ do |key|
  assert( @hash_builder.to_hash[ key ].nil? )
end

Then /^key (.*) from hash builder should be (.*)$/ do |key, value|
  assert_equal( value.escape, @hash_builder.to_hash[ key ] )
end
