module Cron
  module Io

    class User
      include ::HTTParty

      base_uri 'api.cron.io/v1'

      def self.create(username, email, password)
        response = User.post('/users',
                  :query => {:email    => email,
                             :username => username,
                             :password => password
                  }
                 )
        Io.hashify_and_enrich response
      end
    end
  end
end
