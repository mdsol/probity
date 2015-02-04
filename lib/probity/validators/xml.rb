require 'nokogiri'

Probity.validators['application/xml'] = Proc.new do |body|
 Nokogiri::XML(body) { |config| config.options = Nokogiri::XML::ParseOptions::STRICT}
end
