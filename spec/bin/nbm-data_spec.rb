require 'spec_helper'
require 'mixlib/shellout'

describe 'nbm-data' do
  subject do
    Mixlib::ShellOut.new(command).run_command
  end

  context "when there are no arguments" do
    let(:command) { 'bin/nbm-data' }

    it "should display an error message" do
      expect(subject.stderr).to include("Please supply states!")
    end
  end

  context "when states are supplied" do
    context "default format" do
      let(:command) { "bin/nbm-data California" }

      it "should display csv for California", :vcr do
        expect(subject.stdout).to include("California")
      end
    end

    context "csv format specified" do
      let(:command) { "bin/nbm-data --format csv California" }

      it "should display csv for California", :vcr do
        expect(subject.stdout).to include("California")
      end
    end

    context "averages format specified" do
      let(:command) { "bin/nbm-data --format averages California, Washington" }

      it "should display averages for California and Washington", :vcr do
        expect(subject.stdout).to include("0.1572")
      end
    end
  end
end
