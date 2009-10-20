#-------------------------------------------------------------------------------
#   Date: 2008.03.31 -- 10:15:30
# Author: kaineer
#  Brief: Test Dots class
#   Desc: -
#-------------------------------------------------------------------------------

require File.join( File.dirname( __FILE__ ), "nihon_suite" )
require 'ream/nihon/dots'

class DotsTest < Test::Unit::TestCase
  include Ream::Nihon

  # This test should fail if class Dots not found
  #
  def test__class_defined 
    assert_nothing_raised { dots = Dots.new( "..." ) }
  end

  #
  #
  def test__inspect
    dots = Dots.new( "[.,( " )
    assert_equal( "Dots([.,( )", dots.inspect )
  end

  # Test string is created via Dots class :)
  #
  def test__to_s
    dots = Dots.new( "[.,(~\" " )
    assert_equal( "『。、「〜〞 ", dots.to_s )
  end

  def test__try_success_rest_empty
    success = Dots.try( "(~.~)" )
    assert( success.ok? )
    assert( success.rest.empty? )
  end

  def test__try_success_rest_not_empty
    success = Dots.try( "\"toiimasu" )
    assert( success.ok? )
    assert_equal( "toiimasu", success.rest )
  end

  def test_try_failure
    string = "sakana.)"
    failure = Dots.try( string )
    assert( !failure.ok? )
    assert_equal( string, failure.rest )
  end
end

