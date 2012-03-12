require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::User do
  let(:uuid) {`uuidgen`.chomp.gsub('-','') }


  describe "#create" do

    it 'asks to check email and click on link to confirm email address' do
      throwable_email = "#{uuid}@mailinator.com"
      puts "account created for #{throwable_email}"
      result  = Cron::Io::User.create("test-#{uuid}", throwable_email, "test-password")
      result['message'].should ==  'Account created. Please confirm your email address by clicking the link provided in an email we will send you shortly.'
    end

  end
end