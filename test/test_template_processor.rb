require File.join( File.dirname( __FILE__ ), "blog_suite" )

class TestTemplateProcessor < Test::Unit::TestCase
  def teardown
    Ream::Blog::TemplateProcessor.reset
  end
  
  module Check
    def self.pkv( k, v )
      Ream::Blog::TemplateProcessor.process_key_value( k, v )
    end
  end
  
  def test_registration
    eval( %{
      class ::A < Ream::Blog::TemplateProcessor
      end
    } )
    
    assert_equal( A, Ream::Blog::TemplateProcessor[ "a" ] )
  end
  
  def test_reverse_processor
    eval( %{
      class ::Reverse < Ream::Blog::TemplateProcessor
        def self.process( value )
          value.reverse
        end
      end
      
      # just to ensure
      Ream::Blog::TemplateProcessor.register( ::Reverse )
    } )
    
    assert_equal( { "key" => "value" },   Check.pkv( "reverse:key", "eulav" ) )
    assert_equal( { "lock" => "cheese" }, Check.pkv( "lock", "cheese" ) )
  end
  
  #
  def test_with_included_template
    eval( %{
      class ::Reverse < Ream::Blog::TemplateProcessor
        def self.process( value )
          value.reverse
        end
      end
      
      class ::Eval < Ream::Blog::TemplateProcessor
        def self.process( value )
          eval( value ).to_s
        end
      end
      
      # just to ensure
      Ream::Blog::TemplateProcessor.register( Reverse, Eval )
    } )
    
    template = Ream::Template.expand( { 
      "outer" => "value is {key} and {counter} dots.",
      "reverse:key" => "eulav",
      "eval:counter" => "8/2+1"
    } ).with( Ream::Blog::TemplateProcessor )
    
    assert_equal( "value is value and 5 dots.", template[ "outer" ] )
  end
end
