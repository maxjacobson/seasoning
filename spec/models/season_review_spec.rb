# frozen_string_literal: true

require "rails_helper"

RSpec.describe SeasonReview do
  describe ".viewable_by" do
    context "when the review is viewable by anybody" do
      context "and current_human is present" do
        it "includes the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "anybody")

          other_human = Human.create!(handle: "Ashley", email: "ashley@example.com")

          expect(described_class.viewable_by(other_human)).to include(review)
        end
      end

      context "and current human is nil" do
        it "includes the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "anybody")

          expect(described_class.viewable_by(nil)).to include(review)
        end
      end
    end

    context "when the review is only viewable to the author" do
      context "and the viewer is the author" do
        it "includes the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "myself")

          expect(described_class.viewable_by(human)).to include(review)
        end
      end

      context "and the viewer is someone else" do
        it "does not include the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "myself")
          other_human = Human.create!(handle: "Ashley", email: "ashley@example.com")

          expect(described_class.viewable_by(other_human)).not_to include(review)
        end
      end

      context "and the viewer is nil" do
        it "does not include the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "myself")

          expect(described_class.viewable_by(nil)).not_to include(review)
        end
      end
    end

    context "when the review is viewable by mutual followers" do
      context "and the viewer and author are mutual followers" do
        it "includes the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "mutuals")
          other_human = Human.create!(handle: "ashley", email: "ashley@example.com")

          Follow.create!(follower_id: human.id, followee_id: other_human.id)
          Follow.create!(follower_id: other_human.id, followee_id: human.id)

          expect(described_class.viewable_by(other_human)).to include(review)
        end
      end

      context "and the viewer follows the author but not vice versa" do
        it "does not include the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "mutuals")
          other_human = Human.create!(handle: "ashley", email: "ashley@example.com")

          Follow.create!(follower_id: other_human.id, followee_id: human.id)

          expect(described_class.viewable_by(other_human)).not_to include(review)
        end
      end

      context "and the author follows the viewer but not vice versa" do
        it "does not include the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "mutuals")
          other_human = Human.create!(handle: "ashley", email: "ashley@example.com")

          Follow.create!(follower_id: human.id, followee_id: other_human.id)

          expect(described_class.viewable_by(other_human)).not_to include(review)
        end
      end

      context "and the viewer is nil" do
        it "does not include the review" do
          human = Human.create!(handle: "marc", email: "marc@example.com")
          show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
          season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
          review = described_class.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "mutuals")

          expect(described_class.viewable_by(nil)).not_to include(review)
        end
      end
    end
  end
end
