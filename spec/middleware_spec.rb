require 'probity'

describe(Probity::ResponseValidatorMiddleware) do

  context 'missing a validator for the content type' do

    before do
      @inner_app = double
      @response = double
      allow(@response).to receive(:content_type).and_return('magic')
      allow(@inner_app).to receive(:call).and_return([200, {}, @response])
    end

    it 'raises by default' do
      app = described_class.new(@inner_app)
      expect{app.call({})}.to raise_error(RuntimeError, /No validator defined for magic/)
    end

    it 'warns when passed {missing_validator: :warn}' do
      app = described_class.new(@inner_app, missing_validator: :warn)
      expect_any_instance_of(Object).to receive(:warn).once
      expect{app.call({})}.not_to raise_error
    end

    it 'does nothing when passed ignore' do
      app = described_class.new(@inner_app, missing_validator: :ignore)
      expect_any_instance_of(Object).not_to receive(:warn)
      expect{app.call({})}.not_to raise_error
    end

  end

  context 'with an appropriate validator' do

    before do
      @inner_app = double
      @response = double
      @body = 'some_body'
      allow(@response).to receive(:content_type).and_return('application/json')
      allow(@response).to receive(:body).and_return(@body)
      allow(@inner_app).to receive(:call).and_return([201,{'foo' => 'bar'},@response])
    end

    it 'calls the appropriate validator' do
      expect(Probity.validators['application/json']).to receive(:call).with(@body)
      expect(Probity.validators['application/xml']).not_to receive(:call)
      app = described_class.new(@inner_app)
      app.call({})
    end

    it 'passes the response through transparently if no error is raised by the validator' do
      allow(Probity.validators['application/json']).to receive(:call).and_return(nil)
      app = described_class.new(@inner_app)
      expect(app.call({})).to eq([201,{'foo' => 'bar'},@response])
    end

    context 'with an empty body' do

      before do
        @inner_app = double
        @response = double
        @body = ''
        allow(@response).to receive(:content_type).and_return('application/json')
        allow(@response).to receive(:body).and_return(@body)
        allow(@inner_app).to receive(:call).and_return([201,{'foo' => 'bar'},@response])
      end

      it 'validates as normal by default' do
        expect(Probity.validators['application/json']).to receive(:call).with(@body)
        app = described_class.new(@inner_app)
        app.call({})
      end

      it 'raises when passed {blank_body: :raise}' do
        expect(Probity.validators['application/json']).not_to receive(:call)
        app = described_class.new(@inner_app, blank_body: :raise)
        expect{app.call({})}.to raise_error(/Response with an empty body/)
      end

      it 'skips validation when passed {blank_body: :ignore}' do
        expect(Probity.validators['application/json']).not_to receive(:call)
        app = described_class.new(@inner_app, blank_body: :ignore)
        expect{app.call({})}.not_to raise_error
      end

    end

    context "with an array of json strings as the body" do
      before do
        @body = [
          JSON.pretty_generate( {'errors' => {'authentication' => ['Unauthorized']}} ),
          JSON.pretty_generate( {'warning' => "warning"} )
        ]

        allow(@response).to receive(:content_type).and_return('application/json')
        allow(@response).to receive(:body).and_return(@body)
        allow(@inner_app).to receive(:call).and_return([401, {'Content-Type' => 'application/json'}, @body])
      end

      it 'validates the joined json strings by default' do
        expect(Probity.validators['application/json']).to receive(:call).with(@body.join(""))
        app = described_class.new(@inner_app)
        app.call({})
      end

    end

  end

end
