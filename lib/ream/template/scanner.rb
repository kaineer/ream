module Ream
  module Template
    class Scanner
      #
      #
      def scan( source )
        @items = HashBuilder.new

        source.each do |line|
          @line = line.chomp
          scan_line
        end

        @items.to_hash
      end
      
      #
      #
      def scan_line
        if title?    then @items.open( @title )
        elsif close? then @items.close!
        elsif comment? # skip line
        else              @items << strip_start
        end
      end
      
    protected
      #
      def title?; @title = @line[ /^---\s*([\w.:]+)/, 1 ]; end
      
      #
      def close?; /^---/ === @line; end
      
      #
      def comment?; /^\s*#/ === @line; end
      
      #
      def strip_start; @line.sub( /^~/, '' ); end
    end
  end
end
