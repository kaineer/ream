#
#
#
#
#

require 'ream/template'
require 'ream/blog/overrides'
require 'ream/blog/template_processor'

module Ream
  #
  module Blog
    #
    module PageLoader
      def load_template( template_object )
        @parts = expand_object( template_object ).with(
          Ream::Blog::TemplateProcessor
        )
        
        @load_date = Time.now
      end
      
    protected
      #
      def expand_object( template_object )
        case template_object
        when String
          @source = File.expand_path( template_object )
          Ream::Template.scan( @source )
        when Ream::Template::Expand
          @source = nil
          template_object
        else
          raise "Unknown template object: #{template_object.inspect}"
        end
      end
    end
  end
end
