require "cron-io/version"

require 'httparty'
module Cron
  module Io

  private
    def self.hashify_and_enrich(response)
      response.to_hash.merge(
          'code'            => response.response.code,
          'parsed_response' => response.parsed_response
      )
    end

  end
end

require "cron-io/user"
require "cron-io/cron"
