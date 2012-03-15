require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::Cron do
  let(:existing_user_with_2_crons_name) {'croniogem2'}
  let(:existing_user_with_2_crons_pwd ) {'secret'}

  let(:cron_1_id) {"4f5e5b2a04c11ff30e00006a"}
  let(:cron_2_id) {"4f5e5b3c04c11ff30e00006d"}
  let(:cron_1)    {{"id"=>cron_1_id, "name"=>"my cron",   "url"=>"http://example.com", "schedule"=>"30-40 * * * *"}}
  let(:cron_2)    {{"id"=>cron_2_id, "name"=>"my cron 2", "url"=>"http://example.com", "schedule"=>"20-40 * * * *"}}

  describe "#list" do

##########
# SUCCESS
##########

    context "for a user with 2 crons scheduled" do
      use_vcr_cassette "a user with 2 crons/get", :record => :new_episodes

      it 'returns a single cron.io job details' do
        cron = CronIO::Cron.get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd, cron_1_id)
        cron.name    .should == cron_1['name'    ]
        cron.id      .should == cron_1['id'      ]
        cron.url     .should == cron_1['url'     ]
        cron.schedule.should == cron_1['schedule']
      end
    end

###########
## FAILURE
###########

    context "with invalid credentials" do
      use_vcr_cassette "with invalid credentials/get", :record => :new_episodes

      it 'raises a CronIO::CredentialsError' do
        expect {
          CronIO::Cron.get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd + "CREDENTIAL_ERROR", cron_1_id)
        }.to raise_error CronIO::CredentialsError
      end
    end


    describe "with invalid id (corresponds to no scheduled job)" do
      use_vcr_cassette "with invalid cron id/get", :record => :new_episodes
      it 'raises a CronIO::CronNotFoundError' do
        expect {
          CronIO::Cron.get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd, cron_1_id+"AN_ERROR")
        }.to raise_error CronIO::CronNotFoundError
      end
    end

  end
end