require 'ream/nihon/text'

Given /^nihon text source (.*)$/ do |source|
  @text = Ream::Nihon::Text.new( source )
end

Then /^nihon text inspect is (.*)$/ do |result|
  assert_equal( result, @text.to_s )
end
