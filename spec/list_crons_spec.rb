require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::Cron do
  let(:existing_user_name) {'croniogem'}
  let(:existing_user_pwd ) {'secret'}

  let(:existing_user_with_2_crons_name) {'croniogem2'}
  let(:existing_user_with_2_crons_pwd ) {'secret'}

  describe "#list" do

##########
# SUCCESS
##########

    describe "for a virgin user" do
      it 'returns nothing if the user has no crons yet' do
        result  = Cron::Io::Cron.list(existing_user_name, existing_user_pwd)
        result['code'].should == "200"
        result['parsed_response'].should == []
      end
    end


    describe "for a user with 2 crons scheduled" do
      it 'returns the 2 crons details' do
        expected_crons_as_json =  [{"id"=>"4f5e5b2a04c11ff30e00006a", "name"=>"my cron",   "url"=>"http://example.com", "schedule"=>"30-40 * * * *"},
                                   {"id"=>"4f5e5b3c04c11ff30e00006d", "name"=>"my cron 2", "url"=>"http://example.com", "schedule"=>"20-40 * * * *"}
                                  ]
        result  = Cron::Io::Cron.list(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd)
        result['code'].should == "200"
        result['parsed_response'].should == expected_crons_as_json
      end
    end


##########
# FAILURE
##########

    describe "with invalid credentials" do

      it 'returns 403 and a descriptive message' do
        result  = Cron::Io::Cron.list(existing_user_with_2_crons_name, existing_user_with_2_crons_pwd + "CREDENTIAL_ERROR")
        result['code'].should == "403"
        result['parsed_response'].should == {"error"=>"Invalid username or password"}
      end
    end

  end
end