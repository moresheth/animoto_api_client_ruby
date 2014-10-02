require 'net/http'
require 'net/https'

module Animoto
  module HTTPEngines
    class NetHTTPAdapter < Animoto::HTTPEngines::Base
      
      # A map of HTTP verb symbols to the Net::HTTP classes that handle them.
      HTTP_METHOD_MAP   = {
        :head   => Net::HTTP::Head,
        :get    => Net::HTTP::Get,
        :post   => Net::HTTP::Post,
        :put    => Net::HTTP::Put,
        :delete => Net::HTTP::Delete
      }
      
      # @return [String]
      def request method, url, body = nil, headers = {}, options = {}
        uri = URI.parse(url)
        http = build_http uri, options
        req = build_request method, uri, body, headers, options        
        response = http.request req
        [response.code.to_i, response.body]
      end
      
      private

      # Makes a new HTTP object.
      #
      # @param [URI] uri a URI object of the request URL
      # @return [Net::HTTP] the HTTP object
      def build_http uri, options
        http = if options[:proxy]
          proxy_uri = URI.parse(options[:proxy])
          Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new uri.host, uri.port
        else
          Net::HTTP.new uri.host, uri.port
        end
        http.read_timeout = options[:timeout]
        http.use_ssl = true
        http.ssl_version = :SSLv2
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end
      
      # Builds the request object.
      #
      # @param [Symbol] method which HTTP method to use (should be lowercase, i.e. :get instead of :GET)
      # @param [String] uri the request path
      # @param [String,nil] body the request body
      # @param [Hash{String=>String}] headers the request headers (will be sent as-is, which means you should
      #   specify "Content-Type" => "..." instead of, say, :content_type => "...")
      # @param [Hash{Symbol=>Object}] options
      # @return [Net::HTTPRequest] the request object
      def build_request method, uri, body, headers, options
        req = HTTP_METHOD_MAP[method].new uri.path
        req.body = body
        req.initialize_http_header headers
        req.basic_auth options[:username], options[:password]
        req
      end      
    end    
  end
end