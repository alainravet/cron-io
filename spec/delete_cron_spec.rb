require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::Cron do
  describe "#delete" do
    let(:username) {'croniogem2'}
    let(:password) {'secret'    }
    let(:invalid_password) {password + "INVALID"}

    let(:valid_cron_id) {"4f5e5b3c04c11ff30e00006d"}

    def do_delete(cron_id)
      CronIO::Cron.delete(username, password, cron_id)
    end

##########
# SUCCESS
##########

    it 'removes 1 cron job from my cron.io account' do
      VCR.use_cassette("delete cron/with a valid cron id", :record => :new_episodes) do
        CronIO::Cron.list(username, password).length.should == 1
        do_delete(valid_cron_id)
        CronIO::Cron.list(username, password).length.should == 0
      end
    end

##########
# FAILURE
##########

    it "raises a CronIO::CredentialsError when the credentials are invalid" do
      VCR.use_cassette("delete cron/with invalid credentials", :record => :new_episodes) do
        expect {
          CronIO::Cron.delete(username, invalid_password, valid_cron_id)
        }.to raise_error CronIO::CredentialsError
      end
    end

    it "raises a CronIO::CronNotFoundError when the cron id is invalid" do
      VCR.use_cassette("delete cron/with invalid cron id", :record => :new_episodes) do
        expect {
          do_delete('invalid-cron-id')
        }.to raise_error CronIO::CronNotFoundError
      end
    end

  end
end