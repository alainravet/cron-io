module Cron
  module Io
    class Cron
      require 'json'

      attr_reader :id, :name, :url, :schedule

      def initialize(id, name, url, schedule)
        @id, @name, @url, @schedule = id, name, url, schedule
      end

# ----------------------------------------------------------------------

      include ::HTTParty
      base_uri 'api.cron.io/v1'
      headers 'Content-Type' => 'application/json'


      class << self
        alias httpparty_get  get    #to work around the name collision between our 'get' and httpparty's
        alias httpparty_post post
      end

# create
#-----
      def self.create(username, password, name, url, schedule )
        body =  {'name' => name, 'url' => url, 'schedule'   => schedule}
        params = {:basic_auth => {:username => username, :password => password},
                  :body       => body.to_json
        }
        response = Cron.httpparty_post('/crons', params)
        response = Io.hashify_and_enrich response
        errors  = response['errors']

        if response['success']
          new response['id'], response['name'], response['url'], response['schedule']

        else
          # TODO : raise the appropriate error
          puts "ERR-"*44
          puts "+"*99
          puts errors.keys.inspect rescue "NO KEYS"
          puts errors.inspect
          puts "-"*99
          puts response.keys.inspect
          puts response['code'].inspect
          puts response.inspect
          puts "-"*99
          raise CredentialsError.new(errors)
        end
      end

# list
#-----
      def self.list(username, password)
        params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get('/crons', params)
        response = Io.hashify_and_enrich response
        error  = response['errors']

        if response['success']
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
