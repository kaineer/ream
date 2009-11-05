#
#
#

require 'test/unit'
require 'ream/template'

class TC_TemplateExpand < Test::Unit::TestCase
  # 
  module Make
    def self.template( hash )
      Ream::Template.expand( hash )
    end
  end

  def test__template_text()
    template = Make.template( { 'template.text' => 'Test template' } )
    assert_equal( 'Test template', template[ 'template.text' ] )
  end

  def test__template_include()
    template = Make.template( {
      'template.include' => 'Whole and {template.part}',
      'template.part'    => 'part'
    } )
    
    assert_equal( 'Whole and part', template[ 'template.include' ] )
  end

  #
  def test__template_params()
    template = Make.template( 'template.params' => '%white% and %black%' )
    
    assert_equal( '%white% and %black%', template[ 'template.params' ] )
    assert_equal( 'Horse and dog',
      template[ 'template.params', { 'white' => 'Horse', 'black' => 'dog' } ]
    )
  end

  #
  def test__nested_include()
    template = Make.template( {
      'template.outer' => 'Outer: {template.inner}.',
      'template.inner' => 'Inner: {template.inner.outer}',
      'template.inner.outer' => 'template'
    } )
    
    assert_equal( "Outer: Inner: template.", template[ 'template.outer' ] )
  end
 
  #
  #
  def test__searching_for_nowhere
    template = Make.template( { 'template.searching.for.nowhere' => 'Code sample #{nowhere} that is.' } )
    
    assert_equal( "Code sample #\{nowhere\} that is.", 
      template[ "template.searching.for.nowhere" ] )
  end
end

=begin
--- scan.test:text
that is a scan test text
---
=end

class TC_TemplateScanner < Test::Unit::TestCase
  def test_scanner
    template = Ream::Template.scan
    assert_equal( "that is a scan test text", template[ "scan.test:text" ] )
  end
end
