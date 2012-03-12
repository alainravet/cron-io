require "cron-io/version"

require 'httparty'
module Cron
  module Io

    class Error < RuntimeError                            ; end
    class CredentialsError   < Cron::Io::Error            ; end
    class CronNotFoundError  < Cron::Io::Error            ; end
    class UserCreationError  < Cron::Io::Error            ; end
    class UsernameTakenError < Cron::Io::UserCreationError; end
    class InvalidEmailError  < Cron::Io::UserCreationError; end

  private
    def self.hashify_and_enrich(response)
      success = response.response.code.start_with?("20")
      response.to_hash.merge(
          'code'            => response.response.code,
          'parsed_response' => response.parsed_response,
          'success'         => success
      )
    end

  end
end

require "cron-io/user"
require "cron-io/cron"
