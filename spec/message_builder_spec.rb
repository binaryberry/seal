require 'spec_helper'
require './lib/message_builder'
require 'timecop'

describe MessageBuilder do
  let(:pull_requests)   { {"[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host"=>{"title"=>"[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host", "link"=>"https://github.com/alphagov/whitehall/pull/2266", "author"=>"mattbostock", "repo"=>"whitehall", "comments_count"=>"1", "updated"=> Date.parse("2015-07-13 ((2457217j,0s,0n),+0s,2299161j)")}, "Remove all Import-related code"=>{"title"=>"Remove all Import-related code", "link"=>"https://github.com/alphagov/whitehall/pull/2248", "author"=>"tekin", "repo"=>"whitehall", "comments_count"=>"5", "updated"=>Date.parse("2015-07-17 ((2457221j,0s,0n),+0s,2299161j)")}}}
  let(:empty_pull_request) {{}}

  context "informative" do
    it "builds message" do
      message_builder = MessageBuilder.new(pull_requests, "informative")
      expect(message_builder.informative).to eq("Good morning team! \n\n Here are the pull requests that need to be reviewed today:\n\n1) *whitehall* | mattbostock\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n2) *whitehall* | tekin\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n\nMerry reviewing!")
    end

    it "builds happy message" do
      message_builder = MessageBuilder.new(empty_pull_request, "informative")
      expect(message_builder.informative).to eq("Good morning team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:")
    end
  end

  context "angry" do
    context "old PRs" do
      it "builds message" do
        message_builder = MessageBuilder.new(pull_requests, "angry")
        expect(message_builder.angry).to eq("AAAAAAARGH! These pull requests have not been updated in over 2 days.\n\n1) *whitehall* | mattbostock\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n2) *whitehall* | tekin\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n\n\n Remember each time you time you forget to review your pull requests, a baby seal dies.")
      end
    end

    context "no old PRs" do
      it "produces an empty string" do
<<<<<<< HEAD
=======
        require 'pry'
        # binding.pry
>>>>>>> message builder now can produce angry message
        message_builder = MessageBuilder.new(empty_pull_request, "angry")
        expect(message_builder.angry).to eq("")
      end
    end

    context "rotting" do
      context "old PR" do
        before do
          Timecop.freeze(Time.local(2015, 07, 16))
        end

        it "returns true" do
          message_builder = MessageBuilder.new(pull_requests, "angry")
          pull_request = {"title"=>"[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host", "link"=>"https://github.com/alphagov/whitehall/pull/2266", "author"=>"mattbostock", "repo"=>"whitehall", "comments_count"=>"1", "updated"=> Date.parse("2015-07-13 ((2457217j,0s,0n),+0s,2299161j)")}
          expect(message_builder.rotten?(pull_request)).to eq true
        end

        after do
          Timecop.return
        end
      end

      context "recent PR" do
        before do
          Timecop.freeze(Time.local(2015, 07, 15))
        end

        it "returns false" do
          message_builder = MessageBuilder.new(pull_requests, "angry")
          pull_request = {"title"=>"[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host", "link"=>"https://github.com/alphagov/whitehall/pull/2266", "author"=>"mattbostock", "repo"=>"whitehall", "comments_count"=>"1", "updated"=> Date.parse("2015-07-13 ((2457217j,0s,0n),+0s,2299161j)")}
          expect(message_builder.rotten?(pull_request)).to eq false
        end
      end
    end
  end
end
