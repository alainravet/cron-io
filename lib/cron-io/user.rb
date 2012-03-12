module Cron
  module Io
    class User
      include ::HTTParty

      base_uri 'api.cron.io/v1'

      def self.create(username, email, password)
        res = User.post('/users',
                  :query => {:email    => email,
                             :username => username,
                             :password => password
                  }
                 ).to_hash
      end
    end
  end
end
