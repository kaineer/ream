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
end
