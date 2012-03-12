module Cron
  module Io
    class Cron
      include ::HTTParty

      base_uri 'api.cron.io/v1'

      def self.list(username, password)
        res = Cron.get('/crons',
                  :basic_auth=> {:username => username,
                                 :password => password
                  }
                 )
        res.to_hash.merge('code' => res.response.code, 'parsed_response' => res.parsed_response)
      end
    end
  end
end
