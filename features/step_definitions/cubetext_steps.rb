#
Given /^I have loaded cases$/ do
  path = File.join( File.dirname( __FILE__ ), '../cases' )
  @cases = Dir[ "#{path}/*.case" ].map do |fn|
    content = IO.read( fn )
    if /\A(.*)\n---(.*)\n---\n(.*)\Z/m === content
      { :source => $~[1], :config => $~[2], :result => $~[3], :filename => fn }
    else
      raise "Could not parse case (#{fn}):\n#{content}"
    end
  end
end

Then /^all cases should be valid$/ do
  @cases.each do |hash|
    @cubetext = CubeText.new
    @cubetext.config_roles( YAML::load( hash[ :config ] ) )
    @cubetext.parse( hash[ :source ] )

    assert_equal( hash[ :result ], @cubetext.to_html, 
                  "Filename: #{hash[ :filename ]}\nSource: #{hash[ :source ]}\nConfig: #{hash[:config]}\nResult: #{hash[:result]}" )
  end
end
