require File.join( File.dirname( __FILE__ ), 'blog_suite' )

class TestBlogNode < Test::Unit::TestCase
  def new_node( parent )
    Ream::Blog::Node.new( parent )
  end

  def test_creation
    assert_nothing_raised do
      Ream::Blog::Node.new
    end
  end

  def test_siblings
    root = new_node( nil )
    ch1  = new_node( root )
    ch2  = new_node( root )

    assert( !root.children.empty? )
    assert_equal( [ ch1, ch2 ], root.children )
    assert_equal( root, ch1.parent )
    assert_equal( [ ch2 ], ch1.siblings )
    assert_equal( [ ch2 ], ch1.following_siblings )
    assert_equal( [ ch1 ], ch2.previous_siblings )
  end

  def test_ancestors
    root = new_node( nil )
    ch1  = new_node( root )
    ch11 = new_node( ch1 )
    ch111 = new_node( ch11 )

    assert_equal( [ root ], ch1.ancestors )
    assert_equal( [ root, ch1 ], ch11.ancestors )
    assert_equal( [ root, ch1, ch11 ], ch111.ancestors )
  end
end
