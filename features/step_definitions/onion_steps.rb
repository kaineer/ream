require 'ream/onion'

#
#
#

class TestOnionProc
  def initialize( name, value )
    @name = name
    @value = value
  end

  def []( key )
    key == @name ? @value : nil
  end

  def has_key?( key )
    key == @name
  end
end


Given /^I have an onion$/ do
  @onion = Ream::Onion.new
end

Given /^I place a hash into onion:$/ do |table|
  @hash = {}
  table.hashes.each do |hash|
    @hash.merge!( hash[ "name" ] => hash[ "value" ] )
  end

  @onion << @hash
end

Given /^I place a proc into onion which takes (.*) and returns (.*)$/ do |name, value|
  @proc = TestOnionProc.new( name, value )
  @onion << @proc
end

Then /^onion should contain values:$/ do |table|
  table.hashes.each do |hash|
    assert_equal( hash[ "value" ], @onion[ hash[ "name" ] ] )
  end
end

