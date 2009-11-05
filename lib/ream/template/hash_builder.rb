module Ream
  module Template
    class HashBuilder
      def initialize( init_hash = {} )
        @items = init_hash
        @current_item = nil
      end

      def to_hash
        @items
      end

      def open( key )
        @items[ key ] = ( @current_item = String.new )
      end

      def close!
        @current_item = nil
      end
      
      def <<( string )
        if @current_item
          unless @current_item.empty?
            @current_item << $/
          end
          @current_item << string
        end
      end
    end
  end
end
