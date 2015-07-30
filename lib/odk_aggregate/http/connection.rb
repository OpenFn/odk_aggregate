require 'base64'
require 'faraday'
require 'faraday/digestauth'
# Use the Faraday adapter that comes with Typhoeus.
require 'typhoeus/adapters/faraday' if defined? Typhoeus


require 'odk_aggregate/resources/form'
require 'odk_aggregate/resources/submission'


module OdkAggregate
  class Connection

    include OdkAggregate::Configuration
    include OdkAggregate::Form
    include OdkAggregate::Submission

    def initialize(url = nil, username = nil, password = nil)
      url = base_url if url.empty?
      connect(url, username, password)
    end

    private

    def connect(url, username = nil, password = nil)
      @username = username
      @password = password

      @connection ||= Faraday.new(url, connection_options) do |connection|
        connection.request :digest, username, password if username && password
        #connection.response :xml,  :content_type => /\bxml$/, typecast_xml_value: false
        connection.use FaradayMiddleware::Rashify
        connection.response :logger
        connection.adapter Faraday.default_adapter
      end

    end


    def connection_options(username = nil, password = nil)
      @connection_options ||= {
        headers: {
          "X-OpenRosa-Version" => version,
          "Accept-Language" => language,
          "user_agent" => "OdkAggregate Gem #{OdkAggregate.version}"
        },
        request: {
          open_timeout: 10,
          timeout: 30
        },
        ssl: {
          verify: false
        }
      }

      # if username && password
      #   basicAuthString = Base64.strict_encode64("#{username}:#{password}")
      #   @connection_options[:headers]["Authorization"] = "Basic #{basicAuthString}"
      # end

      @connection_options
    end
  end
end
