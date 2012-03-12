module Cron
  module Io
    class Cron
      include ::HTTParty
      class << self
        alias httpparty_get get   #to work around the name collision between our 'get' and httpparty's
      end

      base_uri 'api.cron.io/v1'

      def self.list(username, password)
        params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get('/crons', params)
        Io.hashify_and_enrich response
      end

      def self.get(username, password, cron_id)
        auth_params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get("/crons/#{cron_id}", auth_params)
        Io.hashify_and_enrich response
      end

    end
  end
end
