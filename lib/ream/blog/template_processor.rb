#
module Ream
  module Blog
    class TemplateProcessor
      @@register = {}
      
      def self.reset
        @@register.clear
      end
      
      def self.inherited( klazz )
        register( klazz )
      end
      
      def self.register( *classes )
        classes.each do |klazz|
          @@register[ klazz.name.downcase.gsub( /\:\:/, "_" ) ] = klazz
        end
      end
      
      def self.[]( key ); @@register[ key ]; end
      
      def self.process_key_value( key, value )
        key_parts = key.split( ":" )
        prefix = key_parts.first
        processor = nil
        processor = @@register[ prefix ] unless prefix == key

        if processor
          { key_parts[ 1..-1 ] * ":" => processor.process( value ) }
        else
          { key => value }
        end
      end
    end
  end
end
