#-------------------------------------------------------------------------------
#   Date: 2008.03.28 -- 09:26:43
# Author: kaineer
#  Brief: Test of RomajiParser
#   Desc: -
#-------------------------------------------------------------------------------

require File.join( File.dirname( __FILE__ ), "nihon_suite" )
require 'ream/nihon/romaji_parser.rb'

class RomajiParserTest < Test::Unit::TestCase
  # Utility to make methods below more clear
  #
  def parse_romaji( romaji )
    Ream::Nihon::RomajiParser.parse( romaji.to_s )
  end

  # Define test to check romaji is all right and result with expected one
  #
  def self.check_romaji( romaji, result )
    define_method( "test_#{romaji.to_s}" ) {
      parse_result = parse_romaji( romaji.to_s )
      assert( parse_result.success?, "Romaji should be all right" )
      assert_equal( result, parse_result.arr )
    }
  end

  def self.check_fail_romaji( romaji, left = romaji.to_s )
    define_method( "test_fail_#{romaji}" ) {
      parse_result = parse_romaji( romaji.to_s )
      assert( parse_result.failure?, "Romaji value [#{romaji}] should fail" )
      assert_equal( left, parse_result.str, "Rest of unparsed romaji should be [#{left}]" )
    }
  end

  check_romaji :sakana,     %w( SA KA NA )          # 
  check_romaji :shogun,     %w( SHI yo GU N )       # 
  check_romaji :shi,        %w( SHI )               # 
  check_romaji :daijobu,    %w( DA I JI yo BU )     # 
  check_romaji :dorobou,    %w( DO RO BO U )        # 
  check_romaji "dorobo:",   %w( DO RO BO U )        # same case, semicolon used
  check_romaji :foruku,     %w( FU o RU KU )        # 
  check_romaji :firumu,     %w( FU i RU MU )        # 
  check_romaji :ookii,      %w( O O KI I )          # 
  check_romaji :onna,       %w( O N NA )            # 
  check_romaji :chotto,     %w( CHI yo tsu TO )     # 
  check_romaji :isshoni,    %w( I tsu SHI yo NI )   # 
  check_romaji :etchi,      %w( E tsu CHI )         # 
  check_romaji :ecchi,      %w( E tsu CHI )         # 
  check_romaji "kon'ya",    %w( KO N YA )           # 
  check_romaji :nyobou,     %w( NI yo BO U )        # nyo -> NI yo
  check_romaji :enpitsu,    %w( E N PI TSU )        # N before consonant
  
  check_romaji :patexi,     %w( PA TE i )           # little vowels
  check_romaji :axtsu,      %w( A tsu )             # little tsu

  check_fail_romaji :xxx                            # 
  check_fail_romaji :kudas, "s"                     # partially entered romaji 'kudasai
end

