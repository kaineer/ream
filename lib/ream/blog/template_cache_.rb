#

require 'ream/template'

module Ream
  module Blog
    class TemplateCache
      # :root  => Config.root_dir
      # :masks => Config.template_masks
      #
      def initialize( opts = {} )
        @scan_sources = opts[ :sources ]
        
        unless @scan_sources
          @root_dir = opts[ :root ] || File.expand_path( "." )
          @scan_masks = opts[ :masks ] || "**/*.tpl"
          @scan_masks = [ @scan_masks ] if @scan_masks.is_a?( String )
        end

        @cache = {}
        @call_cache = {}

        scan_templates
      end

      def rescan
        scan_templates
      end

      def fetch( *names )
        result = @call_cache[ names ]
        unless result
          items = names.inject( {} ) do |hash, name|
            items.merge!( fetch_by_name( name ) )
          end
          @call_cache[ names ] =
            ( result = Ream::Template.expand( items ) )
        end
        result
      end

    protected
      #
      def fetch_by_name( name )
        case name
        when Array then fetch( *name )
        when String then ( @cache[ name ] || {} )
        when Hash then name
        else raise "Unknown argument type for TemplateCache#fetch: #{name.inspect}"
        end
      end

      #
      def scan_templates
        @scan_sources ? scan_from_sources : scan_from_filesystem
      end

      #
      def scanner
        @scanner ||= Ream::Template::Scanner.new
      end

      #
      def scan_from_sources
        @scan_sources.each do |key, value|
          @cache[ key ] = scanner.scan( value.split( $/ ) )
        end
      end

      #
      def scan_from_filesystem
        Dir.chdir( @root_dir ) do
          @scan_masks.each do |mask|
            Dir[ mask ].each do |filename|
              key = filename[ /^(.*)\.\w+$/, 1 ]
              @cache[ key ] = scanner.scan( IO.read( filename ) )
            end
          end
        end
      end

    end
  end
end
