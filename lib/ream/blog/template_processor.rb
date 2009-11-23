#
module Ream
  module Blog
    class TemplateProcessor
      # HACK: On several loading, would be better or-assign
      # NOTE: Somehow it's loaded twice, what a mess :(
      #
      @@register ||= {}
      
      # For tests only
      #
      def self.reset
        @@register.clear
      end
      
      # Register new inherited class
      #
      def self.inherited( klazz )
        register( klazz )
      end

      # Processing key-value pair
      #
      #   Parameters:
      #     @prefixed_key - hash key with arbitrary prefix
      #     @value - original hash pair value
      #
      #   Returns:
      #     Hash with unprefixed key and processed value
      #
      def self.process_key_value( prefixed_key, value )
        key, processor = self.key_and_processor( prefixed_key )

        { key => process( value, processor ) }
      end
      
    protected

      # Examples:
      #   TemplateProcessor::Foo -> 'foo'
      #   TemplateProcessor::Blog::Page -> 'blog_page'
      #
      def self.class_name_to_key( class_name )
        class_name.downcase.split( "::" )[ 1..-1 ] * "_"
      end

      # Return key-value processor by key prefix
      #
      def self.[]( key )
        @@register[ key ]
      end
      
      # Add into register hash
      #
      def self.register( *classes )
        classes.each do |klazz|
          @@register[ class_name_to_key( klazz.name ) ] = klazz
        end
      end

      # Check for processor and unprefix key
      #
      def self.key_and_processor( key )
        key_parts = key.split( ":" )

        if key_parts.size > 1 && ( processor = self[ key_parts.shift ] )
          [ key_parts * ":", processor ]
        else
          [ key, nil ]
        end
      end

      # Process value with processor, if any
      #
      def self.process( value, processor )
        processor ? processor.process( value ) : value
      end
    end
  end
end
