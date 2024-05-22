# frozen_string_literal: true

require "rails_helper"

RSpec.describe Episode do
  let(:show) { Show.create!(title: "Not Dead Yet", tmdb_tv_id: 42) }
  let(:season) { Season.create!(show:, tmdb_id: 42, name: "Season 1", season_number: 1, episode_count: 1) }
  let(:episode) { described_class.create!(season:, air_date:, name: "Pilot", tmdb_id: 42, episode_number: 1) }

  describe "#available?" do
    context "when there is an air_date" do
      context "when the air date is today" do
        let(:air_date) { Time.zone.today }

        it "returns true" do
          expect(episode).to be_available
        end
      end

      context "when the air date is in the past" do
        let(:air_date) { 4.days.ago }

        it "returns true" do
          expect(episode).to be_available
        end
      end

      context "when the air date is in the future" do
        let(:air_date) { 3.days.from_now.to_date }

        it "returns false" do
          expect(episode).not_to be_available
        end
      end
    end

    context "when there is no air_date" do
      let(:air_date) { nil }

      it "returns false" do
        expect(episode).not_to be_available
      end
    end
  end
end
