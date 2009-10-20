class CubeText
  class LJRole < CubeText::Role
    include OwnerSyntax
    include Empty

    def initialize
      super( nil )
    end

    def start_tag( extra )
      "[<a href=\"#{extra}.html\">#{extra}@LJ</a>]"
    end
  end

  def self.test_config( tag )
    { "lj_class"   => { "lj" => { "class" => "CubeText::LJRole" } },
      "copyright"  => { "copyright" => { "entity" => "copy" } },
      "nil_attr"   => { "hr" => { "elt" => "hr", "attr" => { "noshade" => nil } } },
      "header_elt" => { "header" => { "elt" => "h2" } },
      "attributes" => { "chapter" => { "elt" => "div", "attr" => { "class" => "chapter" } } }
    }[ tag ]
  end
end
