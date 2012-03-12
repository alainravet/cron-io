module Cron
  module Io
    class Cron
      include ::HTTParty
      class << self
        alias httpparty_get get
      end

      base_uri 'api.cron.io/v1'

      def self.list(username, password)
        res = Cron.httpparty_get('/crons',
                  :basic_auth=> {:username => username, :password => password}
        )
        res.to_hash.merge(
            'code' => res.response.code,
            'parsed_response' => res.parsed_response
        )
      end

      def self.get(username, password, cron_id)
        res = Cron.httpparty_get("/crons/#{cron_id}",
                  :basic_auth=> {:username => username, :password => password}
        )
        res.to_hash.merge(
            'code' => res.response.code,
            'parsed_response' => res.parsed_response
        )
      end

    end
  end
end
