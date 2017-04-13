require "spec_helper"

RSpec.describe Nbm::Data do
  let(:states) { ['California','Oregon','Washington'] }

  it "has a version number" do
    expect(Nbm::Data::VERSION).not_to be nil
  end

  describe ".fetch" do
    subject(:fetch) { Nbm::Data::fetch(states) }


    it "should retrieve CSV results", :vcr do
      expect(CSV.parse(fetch)).to be_an_instance_of(Array).and(
        contain_exactly(
          ["state name", "population", "households", "income below poverty", "median income"],
          ["California", "38660952", "14450824", "0.1572", "69823.7016"],
          ["Oregon", "3996309", "1779290", "0.1594", "53775.8649"],
          ["Washington", "7077005", "3091503", "0.1348", "63192.7444"]
        )
      )
    end
  end

  describe ".fetch_averages" do
    subject(:fetch_averages) { Nbm::Data.fetch_averages(states) }

    it "should retrieve a weighted average across all requested states", :vcr do
      expect(fetch_averages.round(3)).to eq(0.051)
    end
  end
end
