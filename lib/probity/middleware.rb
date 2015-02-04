module Probity

  class ResponseValidatorMiddleware

    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def call(env)
      status, headers, response = @app.call(env)
      validator = Probity.validators[response.content_type]
      if validator
        validator.call(response.body)
      else
        missing_validator(response.content_type)
      end
      [status, headers, response]
    end

    def missing_validator(content_type)
      error = "No validator defined for #{content_type}. Fix this by putting `#{self.class}.validators['#{content_type}'] = Proc.new do |body| ... end` in a test initializer."
      case @options[:missing_validator]
      when nil, :raise
        raise error
      when :warn
        warn(error)
      when :ignore
      end
    end

  end

end
