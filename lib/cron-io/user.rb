module Cron
  module Io
    class User < Base

      def self.create(username, email, password)
        account_details = {:email => email, :username => username, :password => password}
        response = do_post('/users', :query => account_details)

        if response.success?
          response['message']
        else
          errors = response.errors
          raise EmailTakenError   .new(errors)  if (errors['email'   ] && errors['email'   ]['type'] == 'not unique')
          raise UsernameTakenError.new(errors)  if (errors['username'] && errors['username']['type'] == 'not unique')
          raise InvalidEmailError .new(errors)  if errors['email']
          raise UserCreationError .new(errors)
        end
      end

    end
  end
end