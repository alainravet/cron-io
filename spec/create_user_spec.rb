require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::User do
  describe "#create" do

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

#########
# SUCCESS
#########

    it "returns a message inviting to check your email and confirm your account" do
      VCR.use_cassette("create user/with valid parameters", :record => :new_episodes) do
        it = CronIO::User.create(unique_username_1, unique_email_1, "test-password")
        it.should match /Account created.* Please confirm your email address/i
      end
    end

    specify 'the password can be blank' do
      VCR.use_cassette("create user/with valid parameters and a blank password", :record => :new_episodes) do
        msg = CronIO::User.create(unique_username_2, unique_email_2, '')
        msg.should match /Account created.* Please confirm your email address/i
      end
    end

#########
# FAILURE
#########

    it 'raises a CronIO::UsernameTakenError when the username is already taken' do
      VCR.use_cassette("create user/when username already taken", :record => :new_episodes) do
        expect {
          CronIO::User.create(taken_username, unique_email_4, valid_password)
        }.to raise_error CronIO::UsernameTakenError
      end
    end

    it 'raises a CronIO::EmailTakenError when the email is already taken' do
      VCR.use_cassette("create user/when email already taken", :record => :new_episodes) do
        expect {
          CronIO::User.create(taken_username, taken_email, valid_password)
        }.to raise_error CronIO::EmailTakenError
      end
    end

    it 'raises a CronIO::InvalidEmailError when the email is invalid' do
      VCR.use_cassette("create user/with invalid email", :record => :new_episodes) do
        expect {
          an_invalid_email = 'no@@e'
          CronIO::User.create(unique_username_3, an_invalid_email, valid_password)
        }.to raise_error CronIO::InvalidEmailError
      end
    end

  end
end