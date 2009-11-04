require 'ream/blog/node'
require 'ream/blog/page/page_loader'

module Ream
  module Blog
    # Blog page
    #
    class Page < Node
      #
      include PageLoader
      
      # ctor
      #
      def initialize( obj, parent = nil )
        super( parent )

        @parts    = nil
        @index    = false

        load_template( obj )
        #create_crumb unless self.crumb
        apply_environment
        validate!
      end
      
      def index!
        @index = true
      end
      
      def index?
        @index
      end
      
      def validate!
        raise "Page has no menu_name" unless self.menu_name
        raise "Page has no title" unless self.title
      end

      def render( configuration )
        scan_templates( configuration.template_cache )
        configuration.page = self # update in navigation and parameters
        @decoration[ 
          configuration.main_template,   # main page template
          configuration.parameters       # parameters
        ]
      end

      attr_writer   :title
      attr_accessor :crumble
      attr_writer   :author, :templates, :flavours
      attr_reader   :source, :menu_name


      alias :flavour= :flavours=

      def author; @author || @parent.author; end
      def title; @title || @menu_name; end
      
      def templates
        return @templates if @templates
        @parent.templates + ( @flavours || [] )
      end

      def part( part_name )
        part_name = "post:#{part_name}"
        return nil unless @parts.has_template?( part_name )
	      @parts[ part_name ]
      end
      
      def content
        self.part( "content" )
      end

      def path
        (self.ancestors[ 1..-1 ]||[]).map{|p|"/#{p.crumble}"}*"" + "/#{@crumble}"
      end

      def file
        name = self.path.dup
        name << "/" unless name[ -1, 1 ] == "/"
        name << "index.html"
      end
      
      def changed?
        @load_date < File.mtime( @source ) if @source
      end

    protected
      #
      def apply_environment
        environment = self.part( "environment" )
        self.instance_eval( environment ) if environment
      end
      
      #
      def metaclass; class << self; self; end; end
      
      #
      def apply_extensions
        extentions = self.part( "extensions" )
        self.metaclass.module_eval( extensions )
      end

      #
      def scan_templates( template_cache )
        @decorations = template_cache.fetch( self.templates )
      end
    end
  end
end
