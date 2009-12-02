# 2009.12.02

module Ream
  class Shell
    class Interactor
      def initialize( prompt = nil )
        @prompt = prompt
      end

      def read( default_value = nil )
        print prompt_value
        value = gets.chomp
        if default_value && value.empty?
          value = default_value 
        else
          value
        end
      end

    protected
      def prompt_value
        @prompt ? @prompt.value + " " : "$ "
      end
    end
  end # end Shell
end # end Ream
