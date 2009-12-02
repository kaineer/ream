# 2009.12.02

module Ream
  class Shell
    def initialize( executor, interactor = nil )
      @executor = executor
      @keep_going = true
      @got_exception = false
      @exception_message = nil
      @interactor = interactor
    end
    
    attr_reader :exception_message

    def apply( cmdline )
      begin
        @got_exception = false
        @keep_going = @executor.apply( *parse( cmdline ) )
      rescue Exception => e
        @keep_going = true
        @got_exception = true
        @exception_message = e.message
      end
    end

    def running?
      @keep_going
    end

    def got_exception?
      @got_exception
    end

    def run
      while running? do
        begin
          command = read
        rescue Interrupt => ie
          if @executor.responds_to( :exit_message )
            print @executor.exit_message
          end
        end
        apply( command )
      end
    end

  protected
    
    def parse( cmdline )
      args = cmdline.split
      name = args.shift
      [ name, args ]
    end

    def read
      @interactor.read if @interactor
    end
  end
end
