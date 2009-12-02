#
#
#
#
#

require 'yaml'
require 'ream/blog/configuration'

module Ream
  module Blog
    class Transformations
      def initialize( config_file = Ream::Blog::Configuration.transformations )
        @transformation_hashes = YAML.load_file( config_file )
        
        build_transformations
      end

      attr_reader :transformations

    protected
      #
      def build_transformations
        @transformations = []
        
        @transformation_hashes.each do |hash|
          @transformations << Transformation.new( hash )
        end
      end
    end

    class Transformation
      def initialize( hash )
        @hash = hash
        @dir_map = get( :map, :dir )
        @file_map = [ @dir_map, get( :map, :file ) ] * "/"
        @templates = get( :templates ) || []
        @sources = get( :sources ) || []
        @environment = get( :environment ) || {}
      end

      attr_reader :dir_map, :file_map, :templates, :sources

      def get( *args )
        result = @hash
        args.each do |arg|
          result = result[ arg.to_s ] rescue nil
          break unless result
        end
        result
      end
    end
  end
end
