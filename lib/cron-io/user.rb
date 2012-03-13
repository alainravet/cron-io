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
        elsif not_unique_email_detected?(errors)    then raise EmailTakenError   .new(response['errors' ])
        elsif not_unique_username_detected?(errors) then raise UsernameTakenError.new(response['errors' ])
        elsif errors['email']                       then raise InvalidEmailError .new(response['errors' ])
        else
          raise UserCreationError.new(response['errors' ])
        end
      end

    private
      def self.not_unique_email_detected?(errors)
        errors['email'] && errors['email']['type'] == 'not unique'
      end
      def self.not_unique_username_detected?(errors)
        errors['username'] && errors['username']['type'] == 'not unique'
      end
    end
  end
end
