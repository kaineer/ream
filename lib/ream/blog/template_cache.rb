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
      
      attr_reader :source

      def rescan
        scan_sources
      end

      def fetch( *names )
        unless @call_cache[ names ]
          @call_cache[ names ] = Ream::Template.expand( fetch0( *names ) ).with( Ream::Blog::TemplateProcessor )
          @call_cache[ names ].mtime = fetch_mtime( *names )
        end

        @call_cache[ names ]
      end

      def each( &block )
        @source.keys.each do |key|
          value = fetch( key )
          block.call( key, value )
        end
      end

      def files
        return [] unless @source.is_a?( Ream::Sources::FS )
        @source.files
      end

    protected

      def init_cache
        @cache = {}
        @time_cache = {}
        @call_cache = {}
      end

      def scanner
        @scanner ||= Ream::Template::Scanner.new
      end

      def scan_sources
        @source.each do |key, value, time|
          @time_cache[ key ] = ( time || Time.now )
          @cache[ key ] = scanner.scan( value )
        end
      end

      def fetch0( *names )
        names.inject( {} ) do |hash, name|
          hash.merge( fetch_by_name( name ) )
        end
      end

      def fetch_mtime( *names )
        names.inject( Time.mktime( 1980, 1, 1 ) ) do |time, name|
          [ time, fetch_mtime_by_name( name ) ].max
        end
      end

      def fetch_by_name( name )
        case name
        when Array  then fetch0( *name )
        when String then ( @cache[ name ] || {} )
        when Hash   then name
        else raise unknown_argument( name )
        end
      end

      def fetch_mtime_by_name( name )
        case name
        when Array  then fetch_mtime( *name )
        when String then ( @time_cache[ name ] || Time.now )
        else Time.now
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
