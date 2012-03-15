require "cron-io/version"

require 'httparty'
module Cron
  module Io

    class Error < RuntimeError                            ; end

    class CredentialsError   < Cron::Io::Error            ; end

    class CronNotFoundError  < Cron::Io::Error            ; end

    class UserCreationError  < Cron::Io::Error            ; end
    class UsernameTakenError < Cron::Io::UserCreationError; end
    class EmailTakenError    < Cron::Io::UserCreationError; end
    class InvalidEmailError  < Cron::Io::UserCreationError; end

    class CronCreationError  < Cron::Io::Error            ; end
    class QuotaReachedError  < Cron::Io::CronCreationError; end

  end
end

require "cron-io/base"
require "cron-io/user"
require "cron-io/cron"
