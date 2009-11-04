#
#
#
#
#

module Ream
  #
  #
  module Blog
    #
    #
    class Navigation
      #
      #
      def initialize( container )
        @container = container
      end
      
      attr_accessor :page
      
      #
      #
      def previous( count, template_name = nil )
        template_name = "nav_li"
        @page.previous_siblings( count ).map{|page|
          @page.decoration[ template_name,
            { "href" => page.path, "title" => page.menu_name }
          ]
        } * ""
        
        apply_template( 
          @page.previous_siblings( count ),
          @page.decoration[ template_name ] 
        ) { |page|
          { "href" => page.path, "title" => page.menu_name }
        }

      end
      
      #
      def apply_template( data_array, template, &block )
        data_array.map {|element|
          template.expand_params( block.call( element ) )
        } * ""
      end
    end
  end
end
