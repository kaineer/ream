#
#
#
#
#

require 'ream/blog/template_processor'
require 'ream/blog/template_processor/defaults'
require 'ream/blog/template_parameter'
require 'ream/blog/sources'
require 'ream/blog/transformations'
require 'ream/blog/template_cache'
require 'ream/onion'

module Ream
  module Blog
    class Builder
      def initialize
        Ream::Blog::TemplateProcessor.load
        Ream::Blog::TemplateParameter.load
      end

      def build
        transformations.each do |transformation|
          build_transformation( transformation )
        end
      end


    protected

      def build_transformation( transformation )
        transformation.sources.each do |source_name|
          transform_source( transformation, cache( source_name ) )
        end
      end

      def transform_source( transformation, source )
        source.each do |path, value|
          dst_path = path.path.map( transformation.file_map )

          if !File.exist?( dst_path ) || File.mtime( dst_path ) < value.mtime
            layout = templates.fetch( layout_templates( transformation, value ) )
            
            if !File.exist?( dst_path ) || File.mtime( dst_path ) < layout.mtime
              content = layout[ "html:page", template_parameters( path, value ) ]
              write_content( transformation, path, content )
            end
          end
        end
      end

      def write_content( transformation, path, content )
        FileUtils.mkdir_p( path.path.map( transformation.dir_map ) )
        File.open( path.path.map( transformation.file_map ), "w" ) do |f|
          f.write( content )
        end
      end

      def sources
        @sources ||= Ream::Blog::Sources.new
      end

      def transformations
        @transformations ||= 
          Ream::Blog::Transformations.new.transformations
      end

      def cache( sources_name )
        Ream::Blog::TemplateCache.new( sources[ sources_name ] )
      end

      def templates
        @templates ||= cache( "templates.source" )
      end

      def layout_templates( transformation, replacer )
        transformation.templates |
          ( (replacer[ "environment" ][ "templates" ] rescue nil ) || [] )
      end

      def template_parameters( path, replacer )
        result = Ream::Onion.new

        result << { "page:content" => 
          replacer[ "page:content", Ream::Blog::TemplateParameter ],
          "page:path" => path }

        if replacer[ "parameters" ].is_a?( Hash )
          result << replacer[ "parameters" ]
        end

        result
      end
    end
  end
end
