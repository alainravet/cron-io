module CronIO
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

      raise CronNotFoundError.new(response.errors) if response.cron_not_found?
      Cron.new(response['id'], response['name'], response['url'], response['schedule'])
    end


# update
#-----
    def self.update(username, password, cron_id, params)
      body   = {}
      [:name, :url, :schedule].each do |key|
        value = params[key.to_sym] || params[key.to_s]
        body[key.to_s] = value if value
      end
      params = {:basic_auth => {:username => username, :password => password},
                :body       => body.to_json
      }
      response = do_put("/crons/#{cron_id}", params)

      raise CronNotFoundError.new(response.errors) if response.cron_not_found?
    end


# delete
#-----
    def self.delete(username, password, cron_id)
      auth_params = {:basic_auth=> {:username => username, :password => password}}
      response = do_delete("/crons/#{cron_id}", auth_params)

      raise CronNotFoundError.new(response.errors) if response.cron_not_found?
    end

  end
end