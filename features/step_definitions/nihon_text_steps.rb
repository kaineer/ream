require 'ream/nihon/text'

Given /^nihon text source (.*)$/ do |source|
  @text = Ream::Nihon::Text.new( source )
end

Given /^nihon text scans (.*)$/ do |source|
  @result = Ream::Nihon::Text.scan( source )
end

Then /^nihon text inspect is (.*)$/ do |result|
  assert_equal( result, @text.to_s )
end

Then /^nihon text contains (.*)$/ do |tag|
  assert_equal( tag.to_sym, @result )
end
