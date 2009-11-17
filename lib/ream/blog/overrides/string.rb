#==============================================================
#  class: String
#   date: 2009.11.13
#
#  brief: Monkeypatching String: add #path method
#==============================================================

module Ream
  module Overrides
    class Path
      def initialize( string )
        scan( string )
      end

      def map( pattern )
        pattern.gsub( /%(\w)/ ) {|f|
          replace( $~[1] )
        }
      end

      protected
      
      def scan( string )
        @all = string
        if /^(.*)?[\/\\]([^\/\\]*)$/ === string
          @path = $~[1].to_s
          @base = $~[2]
        else
          @path = "."
          @base = string
        end

        scan_name_extension
      end

      def scan_name_extension
        if /^(.*)\.([^.]*)$/ === @base
          @name = $~[1]
          @ext  = $~[2]
        else
          @name = @base
          @ext  = nil
        end
      end

      def path( index )
        @path.split( /\\\// )[ index ]
      end

      def replace( sym )
        case sym
        when 'a' then @all
        when 'p' then @path
        when '0'..'9' then path( sym.to_i )
        when 'b' then @base
        when 'n' then @name
        when 'x' then @ext
        end.to_s
      end
    end
  end
end

class String
  def path
    Ream::Overrides::Path.new( self )
  end
end
