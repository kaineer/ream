#
#
#
#
#

require 'ream/blog/configuration'

module Ream
  #
  module Blog
    #
    class Container
      #
      #
      def initialize
        @config     = Configuration
        @scanner    = PageScanner.new( @config )
        @template_cache = TemplateCache.new( @config )
        @navigation = Navigation.new( self ) # ???
        @parameters = RenderParameters.new( self )
        
        @parameters.navigation = @navigation
        @parameters.config = @config
      end
      
      attr_reader :config, :navigation
      
      #
      def page=( page )
        @navigation.page = page
        @parameters.page = page
      end
      
      #
      #
      def []( key )
        @scanner.pages[ key ]
      end
      
      #
      #
      def build
        @template_cache.rescan # ?
        @scanner.scan_pages
      end
    end
    
    #
    #
    #
    class PageScanner
      #
      #
      #
      def initialize( config )
        @config = config
        @pages = {} # / => root page, /blog/ => blog page etc.
        @root  = nil
      end
      
      #
      attr_reader :root, :pages
      
      #
      def scan_pages
        Dir.chdir( @config.pages_root ) do
          scan_pages( nil, "." )
        end
      end
      
    protected
      # Look for pages in directories
      #

      def scan_pages0( index, directory )
        unless index
          index = Page.new( File.join( directory, "index.src" ) )
          @root = index 
        end
      
        @subdir_pages = get_nondir_pages( directory )
        @nondir_pages = get_subdir_pages( directory )
        
        @nondir_pages.each do |page_src|
          Page.new( page_src, index )
        end
        @subdir_pages.each do |page_src|
          page = Page.new( page_src, index )
          scan_pages( config, page, File.dirname( page_src ) )
        end
      end

      
      # :nodoc: to make it more mockable
      #
      def get_nondir_pages( directory )
        Dir[ File.join( directory, "*/index.src" ) ]
      end
      
      # :nodoc: to make it more mockable
      #
      def get_subdir_pages( directory )
        Dir[ File.join( directory, "*.src" ) ] - Dir[ File.join( directory, "index.src" ) ]
      end
    end
  end
end
