require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::User do
  let(:uuid)            {`uuidgen`.chomp.gsub('-','') }
  let(:throwable_email) { "#{uuid}@mailinator.com"    }

  describe "#create" do

    describe "SUCCESS" do

      it 'asks to check email and click on link to confirm email address' do
        puts "account created for #{throwable_email}"
        result  = Cron::Io::User.create("test-#{uuid}", throwable_email, "test-password")
        result['message'].should ==  'Account created. Please confirm your email address by clicking the link provided in an email we will send you shortly.'
        result['errors'].should be_nil
      end

      it 'works if the password is blank' do
        puts "account created for #{throwable_email}"
        result  = Cron::Io::User.create("test-#{uuid}", throwable_email, "")
        result['message'].should ==  'Account created. Please confirm your email address by clicking the link provided in an email we will send you shortly.'
        result['errors'].should be_nil
      end
    end


    describe "FAILURE" do

      it 'fails if the username is already in used' do
        expected_error = {"name"=>"ValidationError", "message"=>"A user with the username \"test-username\" already exists. This property must be unique.", "path"=>"username", "type"=>"not unique"}

        result  = Cron::Io::User.create("test-username", throwable_email, "test-password")
        result['message'].should be_nil
        result['errors' ].should == {'username' => expected_error}
      end

      it 'fails if the email address is invalid ' do
        invalid_email = "no@@e"
        result  = Cron::Io::User.create("test-#{uuid}", invalid_email, "test-password")
        result['message'].should be_nil
        result['errors' ]["email"]['stack'].should match('email is invalid')
      end
    end

  end
end