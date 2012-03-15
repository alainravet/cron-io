require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CronIO::Cron do
  let(:existing_user_name) {'croniogem'}
  let(:existing_user_pwd ) {'secret'}

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

    context "for a virgin user" do
      use_vcr_cassette "a virgin user/list", :record => :new_episodes

      it 'returns nothing if the user has no crons yet' do
        zero_crons  = CronIO::Cron.list(existing_user_name, existing_user_pwd)
        zero_crons.should be_empty
      end
    end


    context "for a user with 2 crons scheduled" do
      use_vcr_cassette "a user with 2 crons/list", :record => :new_episodes
      it 'returns the 2 crons details' do
        two_crons  = CronIO::Cron.list(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd)
        two_crons.length.should == 2
        two_crons[0].name    .should == cron_1['name'    ]
        two_crons[0].id      .should == cron_1['id'      ]
        two_crons[0].url     .should == cron_1['url'     ]
        two_crons[0].schedule.should == cron_1['schedule']
        two_crons[1].name    .should == cron_2['name'    ]
        two_crons[1].id      .should == cron_2['id'      ]
        two_crons[1].url     .should == cron_2['url'     ]
        two_crons[1].schedule.should == cron_2['schedule']
      end
    end


##########
# FAILURE
##########

    context "with invalid credentials" do
      use_vcr_cassette "with invalid credentials/list", :record => :new_episodes

      it 'raises a CronIO::CredentialsError' do
        expect {
          CronIO::Cron.list(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd + "CREDENTIAL_ERROR")
        }.to raise_error CronIO::CredentialsError
      end
    end

  end
end