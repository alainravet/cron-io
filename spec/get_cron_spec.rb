require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::Cron do
  describe "#get" do
    let(:existing_user_with_2_crons_name) {'croniogem2'}
    let(:existing_user_with_2_crons_pwd ) {'secret'}

    let(:cron_1_id) {"4f5e5b2a04c11ff30e00006a"}
    let(:cron_2_id) {"4f5e5b3c04c11ff30e00006d"}
    let(:cron_1)    {{"id"=>cron_1_id, "name"=>"my cron",   "url"=>"http://example.com", "schedule"=>"30-40 * * * *"}}
    let(:cron_2)    {{"id"=>cron_2_id, "name"=>"my cron 2", "url"=>"http://example.com", "schedule"=>"20-40 * * * *"}}

    def do_get(username, password, cron_id)
      CronIO::Cron.get(username, password, cron_id)
    end

##########
# SUCCESS
##########

    it "returns a single Cron object with all the details retrieved from cron.io" do
      VCR.use_cassette("get cron/a user with 2 crons", :record => :new_episodes) do
        cron = do_get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd, cron_1_id)
        cron.name    .should == cron_1['name'    ]
        cron.id      .should == cron_1['id'      ]
        cron.url     .should == cron_1['url'     ]
        cron.schedule.should == cron_1['schedule']
      end
    end

###########
## FAILURE
###########

    it "raises a CronIO::CredentialsError when the credentials are invalid" do
      VCR.use_cassette("get cron/with invalid credentials", :record => :new_episodes) do
        expect {
          do_get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd + "CREDENTIAL_ERROR", cron_1_id)
        }.to raise_error CronIO::CredentialsError
      end
    end

    it "raises a CronIO::CronNotFoundError when the cron id is invalid" do
      VCR.use_cassette("get cron/with invalid cron id", :record => :new_episodes) do
        expect {
          do_get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd, cron_1_id+"AN_ERROR")
        }.to raise_error CronIO::CronNotFoundError
      end
    end

  end
end