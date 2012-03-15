module Cron::Io
  class Base
    require 'json'

    include ::HTTParty
    base_uri 'api.cron.io/v1'
    headers 'Content-Type' => 'application/json'

    class << self
      alias httpparty_get  get    #to work around the name collision between our 'get' and httpparty's
      alias httpparty_post post

      def success?(response)
        response['success']
      end
      def credential_error?(response)
        response['code'] == '403'
      end


      def do_get(url, params)
        raw_response = httpparty_get(url, params)
        process_response(raw_response)
      end

      def do_post(url, params)
        raw_response = httpparty_post(url, params)
        process_response(raw_response)
      end

  # ------------------------------------------------------------------------------------------------
    private
      def process_response(raw_response)
        response = hashify_and_enrich raw_response
        check_credentials!(response)
        response
      end

      def check_credentials!(response)
        error = response['error'] || response['errors']
        raise CredentialsError.new(error) if credential_error?(response)
      end

      def hashify_and_enrich(response)
        success = response.response.code.start_with?("20")
        response.to_hash.merge(
            'code'            => response.response.code,
            'parsed_response' => response.parsed_response,
            'success'         => success
        )
      end

    end
  end
end