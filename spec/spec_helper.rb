require 'rubygems'
require 'cron-io'

require 'spec'

Spec::Runner.configure do |config|
  config.before(:each) do
  end
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each {|f| require f}
