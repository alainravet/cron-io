module Cron
  module Io
    class User < Base

      def self.create(username, email, password)
        response = User.post('/users',
                  :query => {:email    => email,
                             :username => username,
                             :password => password
                  }
                 )
        response = hashify_and_enrich(response)

        if success?(response)
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