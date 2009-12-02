
require File.join( File.dirname( __FILE__ ), "blog_suite" )

class BlogParametersTest < Test::Unit::TestCase
  #
  #
  def setup
    @parameters = Ream::Blog::Parameters.new
  end

  #
  #
  def test_method_call
    @parameters.expects( :method_name )
    @parameters[ "method_name" ]
  end

  #
  #
  def test_chain_call
    @bowl = mock( :content => :bowl_content )
    @parameters.expects( :bowl ).returns( @bowl )
    result = @parameters[ "bowl.content" ]
    assert_equal( result, :bowl_content )
  end

  #
  #
  def test_call_with_integer_parameter
    @parameters.expects( :apples ).with( 10 )

    @parameters[ "apples(10)" ] 
  end

  #
  #
  def test_call_with_multiply_parameters
    @parameters.expects( :message ).with( "cat", "has", 4, "legs" )

    @parameters[ "message(cat,has,4,legs)" ]
  end

  #
  #
  def test_chain_with_parameter
    @bowl = mock
    @bowl.expects( :content ).with( 3 )
    @parameters.expects( :bowl ).returns( @bowl )

    @parameters[ "bowl.content(3)" ]
  end
end


class BlogRenderParametersTest < Test::Unit::TestCase
  def setup
    @render_parameters = Ream::Blog::RenderParameters.new
  end

  def test_page_call
    @page = mock
    @page.expects( :body ).with( "green", "cat" ).once().returns( :green_cat )
    @render_parameters.page = @page

    # those lines are intentionally identical
    assert_equal( :green_cat, @render_parameters[ "page.body(green,cat)" ] )
    assert_equal( :green_cat, @render_parameters[ "page.body(green,cat)" ] )
  end
end
