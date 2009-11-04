#===============================================================
#  class: Ream::Blog::Parameters
#   date: 2008.11.11
#
#  brief: PostParameters and ConfigParameters 
#         should be derived from here
#===============================================================

module Ream
  module Blog
    class Parameters
      # Base behaviour for base parameters
      # In derived classes this one should include some caching
      def []( call_string )
        call_by_string( call_string )
      end

    protected
      #
      CALL_SEPARATOR = "."
      PARAMETER_SEPARATOR = ","
      CALL_NAME = /^\w+/
      CALL_PARAMS = /\(([\w,]+)\)$/
      
      #
      def call_by_string( method_string )
        split_methods( method_string ).inject( self ) do |obj, method_call|
          obj.send( *method_call )
        end
      end

      #
      #
      def process_parameters( args )
        args.map{|arg|(/^\d+$/===arg) ? arg.to_i : arg}
      end
      
      #
      #
      def split_methods( method_string )
        method_string.split( CALL_SEPARATOR ).map{|method_call|
          split_call( method_call )
        }
      end

      #
      #
      def split_call( method_call )
        name = method_call[ CALL_NAME ]
        params = method_call[ CALL_PARAMS, 1 ].to_s
        [ name, *process_parameters( params.split( PARAMETER_SEPARATOR ) ) ]
      end
    end
  end
end

require 'ream/blog/render_parameters'

