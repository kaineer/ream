#-------------------------------------------------------------------------------
#   Date: 2008.03.28 -- 22:17:00
# Author: kaineer
#  Brief: Test of Kana
#   Desc: Check utf8 output and inspect method
#-------------------------------------------------------------------------------

require File.join( File.dirname( __FILE__ ), "nihon_suite" )
require 'ream/nihon/kana'

#
class KanaTest < Test::Unit::TestCase
  include Ream::Nihon

  #
  def test_correct_kana
    kana = Kana.new( "sakana" )
    assert_equal( "さかな", kana.to_s )                         # plain utf8
    assert_equal( "さかな", kana.to_html )                      # same as to_s, when kana is correct
    assert_equal( "Hiragana(SA,KA,NA)", kana.inspect )
  end

  #
  def test_incorrect_kana
    kana = Kana.new( "kudas" )
    assert_equal( "くだ", kana.to_s )                           # only correct kana here
    assert_equal( "くだ<u>s</u>", kana.to_html )                # unparsed comes underlined
    assert_equal( "Hiragana(KU,DA/s)", kana.inspect )
  end

  #
  def test_katakana
    kana = Kana.new( "foruku", true )
    assert_equal( "フォルク", kana.to_s )                        # utf8 for katakana
    assert_equal( "Katakana(FU,o,RU,KU)", kana.inspect )      # inspect
  end

  #
  def test__try_success_empty_rest
    success = Kana.try( "sakana" )
    assert( success.ok?, "Correct kana parsing should be successful" )
    assert( success.rest.empty?, "After parsing correct kana should be no rest string" )
  end

  #
  def test__try_success_some_rest
    success = Kana.try( "kudas" )
    assert( success.ok?, "This kana should be parsed successfully" )
    assert_equal( "s", success.rest, "After parsing this kana should left `s'" )
  end

  #
  def test__try_failure
    string = "..."
    failure = Kana.try( string )
    assert( !failure.ok? )
    assert( string, failure.rest )
  end

end
