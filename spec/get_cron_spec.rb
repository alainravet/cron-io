require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::Cron do
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

    describe "for a user with 2 crons scheduled" do
      it 'returns a single cron.io job details' do
        result  = Cron::Io::Cron.get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd, cron_1_id)
        result['code'].should == "200"
        result['parsed_response'].should == cron_1
      end
    end

###########
## FAILURE
###########

    describe "with invalid credentials" do

      it 'returns 403 and a descriptive message' do
        result  = Cron::Io::Cron.get(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd + "CREDENTIAL_ERROR", cron_1_id)
        result['code'].should == "403"
        result['parsed_response'].should == {"error"=>"Invalid username or password"}
      end
    end

  end
end