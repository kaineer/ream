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

      def add_key( key )
        @items[ key ] = ( @current_item = String.new )
      end
      
      def <<( string )
        return unless @current_item
        @current_item << $/ unless @current_item.empty?
        @current_item << string
      end
    end
  end
end
