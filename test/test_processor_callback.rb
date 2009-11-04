#
require File.join( File.dirname( __FILE__ ), 'blog_suite' )


class TestProcessorCallback < Test::Unit::TestCase
  # This one just reverses all keys and values
  #
  module ReverseProcessor
    def self.process_key_value( key, value )
      { key.reverse => value.reverse }
    end
  end
  
  # This one reverses values, when keys is prefixed with "reverse:"
  # Same time, key is reduced on this prefix
  #
  module SelectiveReverseProcessor
    def self.process_key_value( key, value )
      reverse_key?( key ) ? { @@name => value.reverse } : { key => value }
    end
      
    def self.reverse_key?( key )
      if /^reverse:(.*)$/ === key
        @@name = $~[1]
        return true
      end
      false
    end
  end
  
  #
  def test_reversing_key_and_value
    template = Ream::Template.expand( { "yek" => "eulav" } ).with( ReverseProcessor )
    assert_equal( "value", template[ "key" ] )
  end

  # only river name should be reversed here
  def test_reversing_selected_value
    template = Ream::Template.expand( {
      "reverse:river" => "ipississim",
      "mountain"      => "fuji"
    } ).with( SelectiveReverseProcessor )
    
    assert_equal( "mississipi", template[ "river" ] )
    assert_equal( "fuji",       template[ "mountain" ] )
  end
end
