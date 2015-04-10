require 'rails_helper'

describe 'github_listener' do
    context "it's 9.45am" do

 		before do
			Timecop.freeze(Time.local("2014-11-25 9:45:00"))
		end
        
        it 'should know it is 9.45am' do
            github_listener = Github_listener.new
            expect(github_listener.time).to eq("9:45")
        end

		after do
			Timecop.return
		end
    end
end