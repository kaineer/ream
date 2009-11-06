#==============================================================
# module: Ream::Template::HashBuilder
#   date: 2009.11.05
#
#  brief: Accumulating templates in hash
#==============================================================

module Ream
  module Template
    class HashBuilder
      # Start hash building
      def initialize( init_hash = {} )
        @items = init_hash
        @current_item = nil
      end

      # Get result hash
      def to_hash
        @items
      end

      # Start template
      def open( key )
        @items[ key ] = ( @current_item = String.new )
      end

      # End template
      def close!
        @current_item = nil
      end
      
      # Add line to current template, if any
      def <<( string )
        if @current_item
          unless @current_item.empty?
            @current_item << $/
          end
          @current_item << string
        end
      end
    end  # HashBuilder
  end  # Template
end  # Ream
