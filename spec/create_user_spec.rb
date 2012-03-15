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

    context "with valid parameters" do
      use_vcr_cassette "create user/with valid parameters", :record => :new_episodes

      subject do
        CronIO::User.create(unique_username_1, unique_email_1, "test-password")
      end

      it 'returns a message inviting to check your email and confirm your account' do
        subject.should match /Account created.* Please confirm your email address/i
      end
    end


    context 'with a blank password' do
      use_vcr_cassette "create user/with valid parameters and a blank password", :record => :new_episodes

      it 'works and returns a message inviting to check your email and confirm your account' do
        msg = CronIO::User.create(unique_username_2, unique_email_2, '')
        msg.should match /Account created.* Please confirm your email address/i
      end
    end

#########
# FAILURE
#########

    context 'when the username is already taken' do
      use_vcr_cassette "create user/when username already taken", :record => :new_episodes

      it 'fails and raises a CronIO::UsernameTakenError' do
        expect {
          CronIO::User.create(taken_username, unique_email_4, valid_password)
        }.to raise_error CronIO::UsernameTakenError
      end
    end

    context 'when the email is already taken' do
      use_vcr_cassette "create user/when email already taken", :record => :new_episodes

      it 'fails and raises a CronIO::EmailTakenError' do
        expect {
          CronIO::User.create(taken_username, taken_email, valid_password)
        }.to raise_error CronIO::EmailTakenError
      end
    end


    context 'with an invalid email' do
      use_vcr_cassette "create user/with invalid email", :record => :new_episodes

      it 'fails and raises a CronIO::InvalidEmailError' do
        expect {
          an_invalid_email = 'no@@e'
          CronIO::User.create(unique_username_3, an_invalid_email, valid_password)
        }.to raise_error CronIO::InvalidEmailError
      end
    end

  end
end