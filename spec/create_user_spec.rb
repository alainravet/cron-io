require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::User do
  let(:uuid)            {`uuidgen`.chomp.gsub('-','') }
  let(:throwable_email) { "#{uuid}@mailinator.com"    }
  let(:invalid_email  ) {"no@@e"                      }

  describe "#create" do

#########
# SUCCESS
#########

    describe "with valid parameters" do
      before do
        @user = Cron::Io::User.create("test-#{uuid}", throwable_email, "test-password")
      end

      it 'returns a Cron::Io::User object' do
        @user.email   .should == throwable_email
        @user.name    .should == "test-#{uuid}"
        @user.password.should == "test-password"
      end
    end


    it 'works even if the password is blank' do
      user, result  = Cron::Io::User.create("test-#{uuid}", throwable_email, "")
      user.email    .should == throwable_email
      user.name     .should == "test-#{uuid}"
      user.password .should == ""
    end


#########
# FAILURE
#########

    describe "FAILURE" do

      it 'fails if the username is already in used' do
        expect {
          Cron::Io::User.create("test-username", throwable_email, "test-password")
        }.to raise_error Cron::Io::UsernameTakenError
      end

      it 'fails if the email address is invalid ' do
        expect {
          Cron::Io::User.create("test-#{uuid}", invalid_email, "test-password")
        }.to raise_error Cron::Io::InvalidEmailError
      end
    end

  end
end