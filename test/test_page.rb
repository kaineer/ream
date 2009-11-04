require File.join( File.dirname( __FILE__ ), "blog_suite" )

class TestBlogPage < Test::Unit::TestCase
  # shortcut
  def page( obj, parent = nil )
    obj = Ream::Template.expand( obj ) if obj.is_a?( Hash )
    Ream::Blog::Page.new( obj, parent )
  end
  
  #
  def content( *args )
    args * $/
  end


  def test_environment
    page = page( {
      "post:environment" => content( 
        "@title = 'FooBar'",
        "self.crumble = 'foo-bar'",
        "self.author = 'kaineer'",
        "@menu_name = 'FB a'",
        "self.templates = %w( html meta theme )"
      ) } 
    )
    
    assert_equal( "FooBar", page.title )
    assert_equal( "foo-bar", page.crumble )
    assert_equal( "kaineer", page.author )
    assert_equal( %w( html meta theme ), page.templates )
  end

  def test_inherited_environment
    root = page( 
      { "post:environment" => content( 
        "self.crumble = ''",
        "self.templates = %w( html meta theme )",
        "@menu_name = 'Root'",
        "self.author = 'kaineer'"
      ) }
    )
    
    child1 = page(
      { "post:environment" => content(
        "@menu_name = 'C1'",
        "self.crumble = 'child1'"
      ) },
      root 
    )
    
    child2 = page(
      { "post:environment" => content(
        "@menu_name = 'C2'",
        "self.flavour = %w( theme2 )",
        "self.crumble = 'child2'"
      ) }, 
      root 
    )
    

    assert_equal( "kaineer", root.author )
    assert_equal( "kaineer", child1.author )

    assert_equal( "/", root.path )
    assert_equal( "/child1", child1.path )
    
    assert_equal( "/index.html", root.file )
    assert_equal( "/child1/index.html", child1.file )

    assert_equal( %w( html meta theme ), child1.templates )
    assert_equal( %w( html meta theme theme2 ), child2.templates )
  end


end

