require "nbm/data/version"
require "faraday_middleware"
require "csv"

module Nbm
  module Data
    NBM_URL = "https://www.broadbandmap.gov"
    DATA_VERSION = "jun2014"

    def self.fips_url(state)
      "/broadbandmap/census/state/#{state}?maxresults=1&format=json"
    end

    def self.data_url(fips)
      "/broadbandmap/demographic/#{DATA_VERSION}/state/ids/#{fips}?format=json"
    end

    def self.connection
      Faraday.new NBM_URL do |connection|
        connection.request :json
        connection.response :json, :content_type => /\bjson$/
        connection.adapter Faraday.default_adapter
      end
    end

    def self.fips_codes(states = [])
      states.map do |s|
        connection.get(fips_url(s)).body["Results"].first.last.first["fips"]
      end
    end

    def self.state_info(codes = [])
      codes.each_slice(10).map do |fips_codes|
        connection.get(data_url(fips_codes.join(','))).body["Results"]
      end.flatten
    end

    def self.fetch_averages(states = [])
      s = state_info(fips_codes(states))

      population_sum = s.inject(0) { |sum, x| sum + x["population"].to_i }

      weighted_sum = s.inject(0) do |sum, x|
        sum + x["population"].to_f/
          population_sum * x["incomeBelowPoverty"].to_f
      end

      weighted_sum/states.size
    end

    def self.fetch(states = [])
      CSV.generate do |csv|
        csv << ["state name",
                "population",
                "households",
                "income below poverty",
                "median income"]

        state_info(fips_codes(states)).each do |state|
          csv << [state["geographyName"],
                  state["population"],
                  state["households"],
                  state["incomeBelowPoverty"],
                  state["medianIncome"]]
        end
      end
    end
  end
end
