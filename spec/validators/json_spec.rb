require 'probity'

describe "Probity's built-in json validator" do

  it 'is callable' do
    expect(Probity.validators['application/json']).to respond_to(:call)
  end

  it 'does not raise on valid json' do
    valid_json = <<-'JSON'
    {"fruit": [
      {"name": "apple",
      "number": 3}
      ]
    }
    JSON
    expect{Probity.validators['application/json'].call(valid_json)}.not_to raise_error
  end

  it 'raises an error on invalid json' do
    expect{Probity.validators['application/json'].call('{"fruit":[,{"name":"apple","number":3}]}')}.to raise_error
  end

end
