require 'ream/nihon/kana'

Given /^hiragana created with (.*)$/ do |romaji|
  @kana = Ream::Nihon::Kana.new( romaji, false )
end

Given /^katakana created with (.*)$/ do |romaji|
  @kana = Ream::Nihon::Kana.new( romaji, true )
end

Given /^kana checks (.*)$/ do |romaji|
  @kana_check = Ream::Nihon::Kana.try( romaji )
end

Then /^kana string should be (.*)$/ do |kana|
  assert_equal( kana, @kana.to_s )
end

Then /^kana html code should be (.*)$/ do |html|
  assert_equal( html, @kana.to_html )
end

Then /^kana inspect should be (.*)$/ do |kana_inspect|
  assert_equal( kana_inspect, @kana.inspect )
end

Then /^kana success should be (true|false)$/ do |success|
  assert_equal( success == "true", @kana_check.ok? )
end

Then /^kana rest should be (.*)$/ do |rest|
  assert_equal( rest, @kana_check.rest )
end

