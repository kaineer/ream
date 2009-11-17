#

class Hash
=begin
  alias :get_value :[]

  def []( *args )
    if args.length == 1
      get_value( args.first )
    else
      args.inject( [] ) do |array, key|
        array + [ get_value( key ) ]
      end
    end
  end
=end
end
