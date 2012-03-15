module Cron
  module Io
    class Cron < Base

      attr_reader :id, :name, :url, :schedule

      def initialize(id, name, url, schedule)
        @id, @name, @url, @schedule = id, name, url, schedule
      end

# ----------------------------------------------------------------------
# create
#-----
      def self.create(username, password, name, url, schedule )
        body =  {'name' => name, 'url' => url, 'schedule'   => schedule}
        params = {:basic_auth => {:username => username, :password => password},
                  :body       => body.to_json
        }
        response = Cron.httpparty_post('/crons', params)
        response = hashify_and_enrich response
        error    = response['error']

        if success?(response)
          new response['id'], response['name'], response['url'], response['schedule']
        elsif credential_error?(response)
          raise CredentialsError.new(error)
        elsif error =~ /quota.*reached/i
          raise QuotaReachedError.new(error)
        else
          raise CronCreationError.new(error)
        end
      end

# list
#-----
      def self.list(username, password)
        params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get('/crons', params)
        response = hashify_and_enrich response
        error  = response['errors']

        if success?(response)
          crons = response['parsed_response'].collect do |details|
            Cron.new(details['id'], details['name'], details['url'], details['schedule'])
          end
        elsif credential_error?(response)
          raise CredentialsError.new(error)
        end
      end

# get
#-----
      def self.get(username, password, cron_id)
        auth_params = {:basic_auth=> {:username => username, :password => password}}
        response = Cron.httpparty_get("/crons/#{cron_id}", auth_params)
        response = hashify_and_enrich(response)
        error  = response['errors']

        if success?(response)
          Cron.new(response['id'], response['name'], response['url'], response['schedule'])
        elsif credential_error?(response)
          raise CredentialsError.new(error)
        else
          raise CronNotFoundError.new(error)
        end
      end

    end
  end
end
