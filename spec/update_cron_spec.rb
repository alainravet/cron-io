require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::Cron do
  describe "#update" do
    let(:username) {'croniogemY'}
    let(:password) {'secret'    }
    let(:invalid_password) {password + "INVALID"}

    let(:valid_cron_id) {"4f60a49833d63c3c200000d0"}

    def do_get(cron_id)
      CronIO::Cron.get(username, password, cron_id)
    end
    def do_update(cron_id, params)
      CronIO::Cron.update(username, password, cron_id, params)
    end

    def new_name_for(name) name + "1" end
    def new_url_for(url)   url  + "1" end
    def new_schedule_for(schedule) schedule == "1 2 3 4 5" ? "1 1 1 1 1" : "1 2 3 4 5" end

##########
# SUCCESS
##########

    describe "update the name" do
      use_vcr_cassette "update cron/change only the name", :record => :new_episodes

      it 'changes the name' do
        name = do_get(valid_cron_id).name
        do_update(valid_cron_id, {'name' => new_name_for(name)})
        do_get(valid_cron_id).name.should == new_name_for(name)
      end
    end

    describe "update the url" do
      use_vcr_cassette "update cron/change only the url", :record => :new_episodes

      it 'changes the name' do
        url = do_get(valid_cron_id).url
        do_update(valid_cron_id, {'url' => new_url_for(url)})
        do_get(valid_cron_id).url.should == new_url_for(url)
      end
    end

    describe "update the url and schedule" do
      use_vcr_cassette "update cron/change the url and schedule", :record => :new_episodes

      it 'changes the url and schedule' do
        before = do_get(valid_cron_id)
        url, schedule = before.url, before.schedule
        do_update(valid_cron_id, {:url  => new_url_for(url), :schedule => new_schedule_for(schedule) })
        after = do_get(valid_cron_id)
        after.url     .should == new_url_for(url)
        after.schedule.should == new_schedule_for(schedule)
      end
    end

##########
# FAILURE
##########

    context "with invalid credentials" do
      use_vcr_cassette "update cron/with invalid credentials", :record => :new_episodes

      it 'raises a CronIO::CredentialsError' do
        expect {
          CronIO::Cron.update(username, invalid_password, valid_cron_id, {})
        }.to raise_error CronIO::CredentialsError
      end
    end

    context "with invalid cron id" do
      use_vcr_cassette "update cron/with invalid cron id", :record => :new_episodes

      it 'raises a CronIO::CronNotFoundError' do
        expect {
          do_update('invalid-cron-id', {})
        }.to raise_error CronIO::CronNotFoundError
      end
    end
  end
end