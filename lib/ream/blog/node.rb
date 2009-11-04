#
#
#
module Ream
  module Blog
    class Node
      #
      #
      def initialize( parent = nil )
        @children = []
	@parent   = parent
	@parent << self if @parent
      end

      #
      #
      #
      attr_reader :parent, :children

      def <<( node )
        @children << node
      end

      #
      #
      #
      def siblings
        return nil unless @parent
	@parent.children.reject{|obj|obj==self}
      end

      #
      #
      #
      def previous_siblings
        return nil unless @parent
        @parent.children[ 0...(index) ] 
      end

      #
      #
      #
      def following_siblings
        return nil unless @parent
	@parent.children[ (index+1)..-1 ]
      end

      #
      #
      #
      def ancestors
        return [] unless @parent
	@parent.ancestors + [ @parent ]
      end

    protected
       #
       #
       def index
       	 return nil unless @parent
	 @parent.children.index( self )
       end
    end
  end
end

