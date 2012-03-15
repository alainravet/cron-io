require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::Cron do
  describe "#list" do
    let(:username) {'croniogem2'}
    let(:password) {'secret'    }
    let(:invalid_password) {password + "INVALID"}

    let(:cron_2_id) {"4f5e5b3c04c11ff30e00006d"}
    let(:cron_2)    {{"id"=>cron_2_id, "name"=>"my cron 2", "url"=>"http://example.com", "schedule"=>"20-40 * * * *"}}

    def do_delete(cron_id)
      CronIO::Cron.delete(username, password, cron_id)
    end

##########
# SUCCESS
##########

    context "with a valid cron id" do
      use_vcr_cassette "delete cron/with a valid cron id", :record => :new_episodes

      it 'removes 1 cron job from my cron.io account' do
        CronIO::Cron.list(username, password).length.should == 1
        do_delete(cron_2_id)

        CronIO::Cron.list(username, password).length.should == 0
      end
    end

##########
# FAILURE
##########

    context "with invalid credentials" do
      use_vcr_cassette "delete cron/with invalid credentials", :record => :new_episodes

      it 'raises a CronIO::CredentialsError' do
        expect {
          CronIO::Cron.delete(username, invalid_password, cron_2_id)
        }.to raise_error CronIO::CredentialsError
      end
    end
  end
end