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
        response = do_post('/crons', params)

        if response.success?
          new response['id'], response['name'], response['url'], response['schedule']
        else
          error = response.error
          raise QuotaReachedError.new(error) if error =~ /quota.*reached/i
          raise CronCreationError.new(error)
        end
      end

# list
#-----
      def self.list(username, password)
        params = {:basic_auth=> {:username => username, :password => password}}
        response = do_get('/crons', params)

        if response.success?
          crons = response['parsed_response'].collect do |details|
            Cron.new(details['id'], details['name'], details['url'], details['schedule'])
          end
        end
      end

# get
#-----
      def self.get(username, password, cron_id)
        auth_params = {:basic_auth=> {:username => username, :password => password}}
        response = do_get("/crons/#{cron_id}", auth_params)

        if response.success?
          Cron.new(response['id'], response['name'], response['url'], response['schedule'])
        else
          raise CronNotFoundError.new(response.errors)
        end
      end

    end
  end
end
