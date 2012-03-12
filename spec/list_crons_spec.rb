require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Cron::Io::Cron do
  let(:existing_user_name) {'croniogem'}
  let(:existing_user_pwd ) {'secret'}

  describe "#list" do

    describe "for a virgin user" do
      it 'returns nothing if the user has no crons yet' do
        result  = Cron::Io::Cron.list(existing_user_name, existing_user_pwd)
        result['code'].should == "200"
        result['parsed_response'].should == []
      end
    end

  end
end