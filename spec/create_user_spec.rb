require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::User do
  let(:uuid)            {`uuidgen`.chomp.gsub('-','') }
  let(:throwable_email) { "#{uuid}@example.com"    }
  let(:invalid_email  ) {"no@@e"                      }

  let(:unique_username_1) {'croniogem_unique_username_1'}
  let(:unique_username_2) {'croniogem_unique_username_2'}
  let(:unique_username_3) {'croniogem_unique_username_3'}
  let(:unique_username_4) {'croniogem_unique_username_4'}
  let(:taken_username   ) {'"test-username"'}
  let(:unique_email_1   ) {"#{unique_username_1}@example.com"}
  let(:unique_email_2   ) {"#{unique_username_2}@example.com"}
  let(:taken_email      ) {"#{unique_username_3}@example.com"}
  let(:unique_email_4   ) {"#{unique_username_4}@example.com"}

  let(:valid_password   ) { 'test-password'}

  describe "#create" do

#########
# SUCCESS
#########

    context "with valid parameters" do
      use_vcr_cassette "create user/with valid parameters", :record => :new_episodes

      before do
        @user = Cron::Io::User.create(unique_username_1, unique_email_1, "test-password")
      end

      it 'returns a Cron::Io::User object' do
        @user.email   .should == unique_email_1
        @user.name    .should == unique_username_1
        @user.password.should == "test-password"
      end
    end


    context 'with blank password' do
      use_vcr_cassette "create user/with valid parameters and a blank password", :record => :new_episodes

      it 'works' do
        user = Cron::Io::User.create(unique_username_2, unique_email_2, '')
        user.email    .should == unique_email_2
        user.name     .should == unique_username_2
        user.password .should == ""
      end
    end

#########
# FAILURE
#########

    context 'when the username is already taken' do
      use_vcr_cassette "create user/when username already taken", :record => :new_episodes

      it 'fails' do
        expect {
          Cron::Io::User.create(taken_username, unique_email_4, valid_password)
        }.to raise_error Cron::Io::UsernameTakenError
      end
    end

    context 'when the email is already taken' do
      use_vcr_cassette "create user/when email already taken", :record => :new_episodes

      it 'fails' do
        expect {
          Cron::Io::User.create(taken_username, taken_email, valid_password)
        }.to raise_error Cron::Io::EmailTakenError
      end
    end


    context 'with an invalid email' do
      use_vcr_cassette "create user/with invalid email", :record => :new_episodes

      it 'fails' do
        expect {
          an_invalid_email = 'no@@e'
          Cron::Io::User.create(unique_username_3, an_invalid_email, valid_password)
        }.to raise_error Cron::Io::InvalidEmailError
      end
    end

  end
end