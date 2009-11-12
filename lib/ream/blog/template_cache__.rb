#
#
#

require 'ream/template'

require File.join( File.dirname( __FILE__ ), "template_processor" )
require File.join( File.dirname( __FILE__ ), "overrides" )

module Ream
  module Blog
    class TemplateCache
      def initialize( source )
        @source = source
        init_cache
        scan_sources
      end

      def rescan
        scan_sources
      end

      def fetch( *names )
        @call_cache[ names ] ||= fetch0( *names )
      end

    protected

      def init_cache
        @cache = {}
        @call_cache = {}
      end

      def scanner
        @scanner ||= Ream::Template::Scanner.new
      end

      def scan_sources
        @source.each do |key, value|
          @cache[ key ] = scanner.scan( value )
        end
      end

      def fetch0( *names )
        items = names.inject( {} ) do |hash, name|
          hash.merge( fetch_by_name( name ) )
        end
        
        Ream::Template.expand( items ).with( Ream::Blog::TemplateProcessor )
      end

      def fetch_by_name( name )
        case name
        when Array  then fetch( *name )
        when String then ( @cache[ name ] || {} )
        when Hash   then name
        else raise unknown_argument( name )
        end
      end

      def unknown_argument( name )
        "Unknown argument type "    \
        "for TemplateCache#fetch: " \
        "#{name.inspect}"
      end
    end
  end
end
