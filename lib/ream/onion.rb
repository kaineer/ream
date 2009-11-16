#===============================================================
#  class: Ream::Onion
#   date: 2005.11.16
#
#  brief: Hashes' multylayer wrapper
#===============================================================

module Ream
  #
  #
  class Onion
    #
    #
    def initialize
      @stack = []
    end

    #
    #
    def push( hash )
      @stack << hash
    end

    def <<( hash )
      @stack << hash
    end

    #
    #
    def drop( till = nil )
      raise "Onion is empty!" if @stack.empty?

      till ||= @stack.last
      until @stack.empty?
        dropped = @stack.pop
        break if till == dropped
      end
      dropped
    end

    #
    #
    def []( key )
      @stack.reverse_each do |hash|
        return hash[ key ] if hash.has_key?( key )
      end
      nil
    end

    #
    #
    def has_key?( key )
      @stack.each do |hash|
        return true if hash.has_key?( key )
      end
      false
    end
  end
end
