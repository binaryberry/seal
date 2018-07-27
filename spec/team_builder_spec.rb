require "spec_helper"
require "fakefs/spec_helpers"
require_relative "../lib/team_builder"

RSpec.describe TeamBuilder do
  include FakeFS::SpecHelpers

  let(:organisation) { "big_cats" }

  before do
    FileUtils.mkdir_p(File.join(File.dirname(__FILE__), "../config"))
    File.write(File.join(File.dirname(__FILE__), "../config/#{organisation}.yml"), YAML.dump(
      lions: {
        members: [
          "lil lion",
          "snoop lion",
          "biggy smalls",
        ],
        channel: "#lions",
        exclude_titles: [
          "DO NOT MERGE",
          "WIP",
        ],
        exclude_labels: [
          "DO NOT MERGE",
          "WIP",
        ],
        use_labels: true,
        compact: true,
        quotes: [
          "This is a quote",
          "This is also a quote",
        ],
      },
      tigers: {
        members: [
          "tony",
          "stripey",
          "biggy smalls",
        ],
        channel: "#tigers",
      },
    ))
  end

  let(:env) { {"SEAL_ORGANISATION" => organisation} }

  let(:teams) { TeamBuilder.build(env: env) }

  it "loads each team from the static config file" do
    expect(teams.count).to eq(2)
    expect(teams.map(&:channel)).to match_array(["#lions", "#tigers"])
  end

  it "loads all keys" do
    lions = teams.find {|t| t.channel == "#lions"}

    expect(lions.members).to eq([
      "lil lion",
      "snoop lion",
      "biggy smalls",
    ])

    expect(lions.exclude_titles).to eq([
      "DO NOT MERGE",
      "WIP",
    ])

    expect(lions.exclude_labels).to eq([
      "DO NOT MERGE",
      "WIP",
    ])

    expect(lions.use_labels).to eq(true)
    expect(lions.compact).to eq(true)

    expect(lions.quotes).to eq([
      "This is a quote",
      "This is also a quote",
    ])
  end

  it "provides sensible defaults" do
    tigers = teams.find {|t| t.channel == "#tigers"}

    expect(tigers.exclude_titles).to eq([])
    expect(tigers.exclude_labels).to eq([])
    expect(tigers.use_labels).to eq(false)
    expect(tigers.compact).to eq(false)
    expect(tigers.quotes).to eq([])
    expect(tigers.include_repos).to eq([])
    expect(tigers.exclude_repos).to eq([])
  end

  it "allows the overriding of options via environment variables" do
    env.merge!("GITHUB_EXCLUDE_LABELS" => "new,labels")

    teams.each do |team|
      expect(team.exclude_labels).to eq(["new", "labels"])
    end
  end

  it "allows the selection of a single team" do
    teams = TeamBuilder.build(env: env, team_name: "tigers")

    expect(teams.count).to eq(1)
    expect(teams.first.channel).to eq("#tigers")
  end
end
