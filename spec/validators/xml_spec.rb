require 'probity'

describe "Probity's built-in xml validator" do

  it 'is callable' do
    expect(Probity.validators['application/xml']).to respond_to(:call)
  end

  it 'does not raise on valid xml' do
    valid_xml = <<-'XML'
<?xml version="1.0"?>
<?xml-stylesheet href="example.xsl" type="text/xsl"?>
<!DOCTYPE example SYSTEM "example.dtd">
<fruit>
   <apple color="red" image="red_apple_1.jpg">
      <condition>Fresh</condition>
   </apple>
</fruit>
    XML
    expect{Probity.validators['application/xml'].call(valid_xml)}.not_to raise_error
  end

  it 'raises an error on invalid xml' do
    expect{Probity.validators['application/xml'].call('<a></b>')}.to raise_error
  end

end
