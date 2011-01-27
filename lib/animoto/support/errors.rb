module Animoto
  # This is the base class that all Animoto-specific errors descend from.
  class Error < StandardError
  end

  # Raised when an abstract method is called.
  class AbstractMethodError < Animoto::Error
  end
  
  # Raised when something goes wrong over HTTP
  class HTTPError < Animoto::Error
    CODE_STRINGS = Hash.new("Error").merge({
      400 => "Bad Request",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      405 => "Method Not Allowed",
      406 => "Not Acceptable",
      410 => "Gone",
      411 => "Length Required",
      413 => "Request Entity Too Large",
      415 => "Unsupported Media Type",
      500 => "Internal Server Error",
      501 => "Not Implemented",
      503 => "Service Unavailable"
    })
    
    attr_reader :url, :code, :details
    
    def initialize url, code, body
      @url, @code = url, code
      @details = body['response']['status']['errors'] rescue []
      str = "HTTP #{@code} (#{CODE_STRINGS[@code]}) when requesting #{@url.inspect}"
      str += "\n#{@details.join("\n")}" unless @details.empty?
      super str
    end
  end
end