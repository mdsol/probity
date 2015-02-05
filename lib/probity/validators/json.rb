require 'json'

Probity.validators['application/json'] = Proc.new do |body|
 JSON.parse(body)
end
