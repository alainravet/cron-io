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
                 )
        res.to_hash.merge('code' => res.response.code, 'parsed_response' => res.parsed_response)
      end
    end
  end
end
