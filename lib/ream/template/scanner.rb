#==============================================================
#  class: Ream::Template::Scanner
#   date: 2009.11.06
#
#  brief: Scan through source (IO, array, foo with each)
#==============================================================

module Ream
  module Template
    class Scanner
      # Scanning each source line
      def scan( source )
        @items = HashBuilder.new

        source.each do |line|
          scan_line( line.chomp )
        end

        @items.to_hash
      end
      
      # Regexps for:
      module RE
        TITLE = /^---\s*([\w.:]+)/  # Template start, \1 - template name
        CLOSE = /^---\s*$/          # Finished last template
        COMMENT = /^\s*#/           # Comment line
        START_ESC = /^~/            # Strip escaping tilda
      end

      # Scan current line
      def scan_line( line )
        case line
        when RE::TITLE then @items.open( @title = $~[1] )
        when RE::CLOSE then @items.close!
        when RE::COMMENT # ignore line
        else @items << line.sub( RE::START_ESC, '' )
        end
      end
    end
  end
end
