# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefreshEpisodes do
  describe ".call" do
    context "when the episodes have not yet been imported" do
      it "imports the episodes" do
        request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
                  .to_return(
                    status: 200,
                    body: Rails.root.join("spec/fixtures/tmdb/night-court-season-1.json").read
                  )

        show = Show.create!(
          title: "Night Court",
          tmdb_tv_id: 202_101,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season = show.seasons.create!(
          tmdb_id: 293_954,
          name: "Season 1",
          season_number: 1,
          episode_count: 3,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        RefreshEpisodes.call(show, season)

        expect(request).to have_been_requested
        expect(season.episodes.count).to be 3
        episode = season.episodes.find_by!(episode_number: 2)
        expect(episode.name).to eq "The Nighthawks"
        expect(episode.tmdb_id).to eq 4_149_045
      end
    end

    context "when the episodes have 100% already been imported" do
      it "does nothing" do
        request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
                  .to_return(
                    status: 200,
                    body: Rails.root.join("spec/fixtures/tmdb/night-court-season-1.json").read
                  )

        show = Show.create!(
          title: "Night Court",
          tmdb_tv_id: 202_101,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season = show.seasons.create!(
          tmdb_id: 293_954,
          name: "Season 1",
          season_number: 1,
          episode_count: 9,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season.episodes.create!(
          name: "Pilot",
          tmdb_id: 3_724_869,
          episode_number: 1
        )

        season.episodes.create!(
          name: "The Nighthawks",
          tmdb_id: 4_149_045,
          episode_number: 2
        )

        season.episodes.create!(
          name: "Just Tuesday",
          tmdb_id: 4_044_637,
          episode_number: 3
        )

        RefreshEpisodes.call(show, season)

        expect(request).to have_been_requested
        expect(season.episodes.count).to be 3
        episode = season.episodes.find_by!(episode_number: 2)
        expect(episode.name).to eq "The Nighthawks"
        expect(episode.tmdb_id).to eq 4_149_045
      end
    end

    context "when there are some new episodes to import" do
      it "imports the new episodes and doesn't touch the old ones" do
        request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
                  .to_return(
                    status: 200,
                    body: Rails.root.join("spec/fixtures/tmdb/night-court-season-1.json").read
                  )

        show = Show.create!(
          title: "Night Court",
          tmdb_tv_id: 202_101,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season = show.seasons.create!(
          tmdb_id: 293_954,
          name: "Season 1",
          season_number: 1,
          episode_count: 9,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season.episodes.create!(
          name: "Pilot",
          tmdb_id: 3_724_869,
          episode_number: 1
        )

        season.episodes.create!(
          name: "The Nighthawks",
          tmdb_id: 4_149_045,
          episode_number: 2
        )

        RefreshEpisodes.call(show, season)

        expect(request).to have_been_requested
        expect(season.episodes.count).to be 3
        episode = season.episodes.find_by!(episode_number: 3)
        expect(episode.name).to eq "Just Tuesday"
        expect(episode.tmdb_id).to eq 4_044_637
      end
    end

    context "when the episodes have been rearranged" do
      it "updates the arrangement of the existing episodes" do
        request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
                  .to_return(
                    status: 200,
                    body: Rails.root.join("spec/fixtures/tmdb/night-court-season-1.json").read
                  )

        show = Show.create!(
          title: "Night Court",
          tmdb_tv_id: 202_101,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season = show.seasons.create!(
          tmdb_id: 293_954,
          name: "Season 1",
          season_number: 1,
          episode_count: 9,
          tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
        )

        season.episodes.create!(
          name: "Pilot",
          tmdb_id: 3_724_869,
          episode_number: 1
        )

        season.episodes.create!(
          name: "Just Tuesday",
          tmdb_id: 4_044_637,
          episode_number: 2
        )

        season.episodes.create!(
          name: "The Nighthawks",
          tmdb_id: 4_149_045,
          episode_number: 3
        )

        RefreshEpisodes.call(show, season)

        expect(request).to have_been_requested
        expect(season.episodes.count).to be 3
        episode = season.episodes.find_by!(episode_number: 2)
        expect(episode.name).to eq "The Nighthawks"
        expect(episode.tmdb_id).to eq 4_149_045
      end
    end
  end
end
