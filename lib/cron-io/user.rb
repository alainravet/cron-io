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
        response = Io.hashify_and_enrich(response)

        if response['success']
          response['message']
        else
          raise specific_exception_for(response['errors'])
        end
      end

  # ----------------------------------------------------------------------
    private
      def self.specific_exception_for(errors)
        if (errors['email'] && errors['email']['type'] == 'not unique')
          EmailTakenError.new(errors)
        elsif (errors['username'] && errors['username']['type'] == 'not unique')
          UsernameTakenError.new(errors)
        elsif errors['email']
          InvalidEmailError.new(errors)
        else
          UserCreationError.new(errors)
        end
      end

    end
  end
end