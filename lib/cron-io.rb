require "cron-io/version"

require 'httparty'
module Cron
  module Io
  end
end
module CronIO
  class Error < RuntimeError                  ; end

  class CredentialsError   < CronIO::Error    ; end

  class CronNotFoundError  < CronIO::Error    ; end

  class UserCreationError  < CronIO::Error    ; end
  class UsernameTakenError < UserCreationError; end
  class EmailTakenError    < UserCreationError; end
  class InvalidEmailError  < UserCreationError; end

  class CronCreationError  < CronIO::Error    ; end
  class QuotaReachedError  < CronCreationError; end

  class UserUpdateError    < CronIO::Error    ; end
end

require "cron-io/base"
require "cron-io/user"
require "cron-io/cron"
