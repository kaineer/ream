module Ream
  class Shell
    def initialize( executor )
      @executor = executor
    end

    def apply( cmdline )
      @executor.apply( cmdline )
    end
  end
end
