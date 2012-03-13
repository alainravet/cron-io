module Cron
  module Io
    class Cron

      attr_reader :id, :name, :url, :schedule

      def initialize(id, name, url, schedule)
        @id, @name, @url, @schedule = id, name, url, schedule
      end

      include ::HTTParty
      class << self
        alias httpparty_get get   #to work around the name collision between our 'get' and httpparty's
      end

      base_uri 'api.cron.io/v1'


# list
#-----
      def self.list(username, password)
        params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get('/crons', params)
        response = Io.hashify_and_enrich response
        error  = response['errors']

        if response['success']
          puts "A"*88
          puts response['parsed_response'].inspect
          crons = response['parsed_response'].collect do |details|
            Cron.new(details['id'], details['name'], details['url'], details['schedule'])
          end
        else
          raise CredentialsError.new(error)
        end
      end

# get
#-----
      def self.get(username, password, cron_id)
        auth_params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get("/crons/#{cron_id}", auth_params)
        response = Io.hashify_and_enrich(response)
        error  = response['errors']

        if response['success']
          Cron.new(response['id'], response['name'], response['url'], response['schedule'])
        elsif response['code'] == '403'
          raise CredentialsError.new(error)
        else
          raise CronNotFoundError.new(error)
        end
      end

    end
  end
end
