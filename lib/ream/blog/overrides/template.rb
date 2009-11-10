#
#
#
#
#
module Ream
  module Template
    module RE
      # So, we can use parameters like %navigation.following(16)%
      def self.expand_params; /%([-\w.\(,\)]+)%/; end
    end
    
    class Replacer
      def with( processor )
        Replacer.new( 
          @items.inject( {} ) do |hash, pair|
            new_key_value = processor.process_key_value( *pair )
            hash.merge( new_key_value )
          end
        )
      end
    end
  end
end
