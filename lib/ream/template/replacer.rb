#==============================================================
# module: Ream::Template::Replacer
#   date: 2009.11.06
#
#  brief: Expanding capabilities for templates
#==============================================================

module Ream
  module Template
    class Replacer
      def initialize( items )
        @items = items
      end

      def []( name, params = {} )
        expand_template( name, params )
      end

      def has_template?( name )
        @items.has_key?( name )
      end

    protected

      def expand_template( name, params )
        return unknown_template( name ) unless has_template?( name )
        return @items[ name ] unless @items[ name ].is_a?( String )
        expand_params( expand_includes( @items[ name ], params ), params )
      end

      # Replace template placeholders
      def expand_includes( text, params )
        text.gsub( RE.expand_includes ) { || 
          expand_template( $~[1], params ) 
        }
      end

      # Replace parameters placeholders
      def expand_params( text, params )
puts "Expanding text: #{text}"
puts "with params: #{params.to_yaml}"
        text.gsub( RE.expand_params ) { |f| 
          name = $~[1]
puts "Expanding: #{name}"
          if params.has_key?( name ) 
            params[ name ] 
          else
            puts "--- params #{name} not found ---"
            f
          end
        }
      end

      def unknown_template( name )
        "\{#{name}\}"
      end
    end
  end
end
