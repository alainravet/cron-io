module Cron
  module Io

    class User
      attr_reader :name, :email, :password

      def initialize(username, email, password)
        @name, @email, @password = username, email, password
      end

      include ::HTTParty

      base_uri 'api.cron.io/v1'

      def self.create(username, email, password)
        response = User.post('/users',
                  :query => {:email    => email,
                             :username => username,
                             :password => password
                  }
                 )
        response = Io.hashify_and_enrich(response)
        errors   = response['errors']

        if response['success']
          new(username, email, password)
        elsif errors['email']
          raise InvalidEmailError.new(response['errors' ])
        elsif errors['username']
          raise UsernameTakenError.new(response['errors' ])
        else
          raise Cron::Io::UserCreationError.new(response['errors' ])
        end
      end
    end
  end
end
