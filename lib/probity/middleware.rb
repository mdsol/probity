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
        validate(response.body, validator)
      else
        missing_validator(response.content_type)
      end
      [status, headers, response]
    end

    def validate(body, validator)
      if blank_string?(body)
        blank_body(body, validator)
      else
        validator.call(body)
      end
    end

    def blank_string?(str)
      ! str[/\S/]
    end

    def blank_body(body, validator)
      case @options[:blank_body]
      when nil, :validate
        validator.call(body)
      when :raise
        raise 'Response with an empty body'
      when :ignore
      end
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
