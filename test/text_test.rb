require File.join( File.dirname( __FILE__ ), "nihon_suite" )
require 'ream/nihon/text'


class TC_Text # < Test::Unit::TestCase
	include Ream::Nihon

	def test_text_parsing
		cases = {
			"sakana" => "Hiragana(SA,KA,NA)",
			"/piano" => "Katakana(PI,A,NO)",
			"{EEEE,FFFF}" => "Kanji(EEEE,FFFF)",
			"/purezento{EEEE}owaru" => "Katakana(PU,RE,ZE,N,TO);Kanji(EEEE);Hiragana(O,WA,RU)",
			"{9B5A:sakana}" => "Kanji(9B5A:Hiragana(SA,KA,NA))",
			"/fu-ku" => "Katakana(FU);Dots(-);Katakana(KU)",
			"-in"    => "Dots(-);Hiragana(I,N)",
			"(arigatou)toiimashita" => "Dots(();Hiragana(A,RI,GA,TO,U);Dots());Hiragana(TO,I,I,MA,SHI,TA)"
		}
		
		cases.each do |k,v|
			assert_equal(
				v,
				Text.new( k ).to_s )
		end
	end
end
