require 'rails_helper'

describe 'github_listener' do

    it 'should be able to list ongoing pull requests' do
        account=["binaryberry"]
        github_listener = Github_listener.new(account)
        expect(github_listener.check_pr).to eq(["testing things"])
    end
end