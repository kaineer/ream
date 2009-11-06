#
#
#
#
#

require 'ream/template'

module Ream
  #
  module Blog
    #
    class TemplateCache
      #
      #
      #
      def initialize( config )
        @root_dir = config.templates_root
        @cache = {}
        
        @call_cache = {}
        
        scan_templates
      end

      #
      #
      #
      def rescan
        scan_templates
      end

      #
      #
      #
      def fetch( *names )
        result = @call_cache[ names ]
        unless result
          result = {}
          names.each do |name|
            case name
            when Array  then result.merge!( fetch( *name ) )
            when String then result.merge!( @cache[ name ] || {} )
            when Hash   then result.merge!( name )
            else raise "Unknown argument type for TemplateCache#fetch: #{name.inspect}"
            end
          end
          result = Ream::Template.expand( result )
          @call_cache[ names ] = result
        end
        result
      end
  
    protected
      #
      def scan_templates
        @scanner = Ream::Template::Scanner.new
        Dir.chdir( @root_dir ) do
          Dir[ "**/*.tpl" ].each do |filename|
            key = filename[ /^(.*)\.tpl$/, 1 ]
            @cache[ key ] = @scanner.scan( filename )
          end
        end
      end
    end
  end
end
