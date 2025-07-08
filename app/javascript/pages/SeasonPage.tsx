import { GuestContext, SetLoadingContext } from "../contexts";
import { useContext, useEffect, useState } from "react";
import { AirDate } from "../components/AirDate";
import { MoreInfo } from "../components/MoreInfo";
import { Poster } from "../components/Poster";
import { SeenEpisodeCheckbox } from "../components/SeenEpisodeCheckbox";
import { setHeadTitle } from "../hooks";
import { ShowMetadata } from "../components/ShowMetadata";
import { useParams } from "react-router";
import { YourSeason } from "../types";

interface LoadingSeason {
  loading: true;
}

interface SeasonNotFound {
  loading: false;
  yourSeason: null;
}

interface SeasonFound {
  loading: false;
  yourSeason: YourSeason;
}

type SeasonData = LoadingSeason | SeasonNotFound | SeasonFound;

export const SeasonPage = () => {
  const [response, setResponse] = useState<SeasonData>({ loading: true });
  const setLoading = useContext(SetLoadingContext);
  const { showSlug, seasonSlug } = useParams();
  const guest = useContext(GuestContext);

  useEffect(() => {
    if (!seasonSlug) {
      return;
    }

    (async () => {
      setLoading(true);
      const response = await fetch(
        `/api/shows/${showSlug}/seasons/${seasonSlug}.json`,
        {
          credentials: "same-origin",
        },
      );
      setLoading(false);

      if (response.status === 404) {
        setResponse({ loading: false, yourSeason: null });
      } else if (response.ok) {
        const yourSeason = (await response.json()) as YourSeason;
        setResponse({ loading: false, yourSeason: yourSeason });
      } else {
        throw new Error("Could not load season");
      }
    })();
  }, [showSlug, seasonSlug]);

  let headTitle;

  if (!response.loading && response.yourSeason) {
    headTitle = `${response.yourSeason.show.title} - ${response.yourSeason.season.name}`;
  }

  setHeadTitle(headTitle, [response]);

  if (response.loading) {
    return <div>Loading...</div>;
  }

  const { yourSeason } = response;

  if (!yourSeason) {
    return (
      <div>
        <h1 className="text-xl">Not found</h1>
        <p>Season does not exist!</p>
        <p>
          <a href={`/shows/${showSlug}`}>Back</a>
        </p>
      </div>
    );
  }

  return (
    <div>
      <h1 className="text-xl">{yourSeason.show.title}</h1>
      <h2 className="text-lg">{yourSeason.season.name}</h2>
      <MoreInfo
        url={`https://www.themoviedb.org/tv/${yourSeason.show.tmdb_tv_id}/season/${yourSeason.season.season_number}`}
      />
      <p>
        <a href={`/shows/${showSlug}`}>Back</a>
      </p>

      <div>
        <div>
          <Poster
            url={yourSeason.season.poster_url}
            size="large"
            show={yourSeason.show}
          />
        </div>
        <div>
          <h2 className="text-lg">Season info</h2>

          <div>
            <table className="w-full">
              <thead>
                <tr>
                  <th className="text-left">Number</th>
                  <th className="text-left">Name</th>
                  <th className="text-left">Air date</th>
                  {guest.authenticated && <th className="text-left">Seen?</th>}
                </tr>
              </thead>
              <tbody>
                {yourSeason.season.episodes.map((episode) => {
                  return (
                    <tr key={episode.episode_number}>
                      <td>{episode.episode_number}</td>
                      <td>
                        <a
                          href={`/shows/${showSlug}/${seasonSlug}/${episode.episode_number}`}
                        >
                          {episode.name}
                        </a>
                      </td>
                      <td>
                        <AirDate date={episode.air_date} />
                      </td>
                      {guest.authenticated && yourSeason.your_relationship && (
                        <td>
                          <SeenEpisodeCheckbox
                            episode={episode}
                            season={yourSeason.season}
                            guest={guest}
                            yourRelationshipToSeason={
                              yourSeason.your_relationship
                            }
                          />
                        </td>
                      )}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {guest.authenticated && yourSeason.your_reviews && (
        <div>
          <h2 className="text-lg">Your review</h2>
          <div>
            <a
              href={`/shows/${yourSeason.show.slug}/${yourSeason.season.slug}/reviews/new`}
            >
              <span className="underlined">Add review</span>
            </a>
          </div>
          <div>
            {yourSeason.your_reviews.length ? (
              <ul>
                {yourSeason.your_reviews.map((review, i) => {
                  return (
                    <li key={i}>
                      <a
                        href={`/${guest.human.handle}/shows/${yourSeason.show.slug}/${
                          yourSeason.season.slug
                        }${review.viewing === 1 ? "" : `/${review.viewing}`}`}
                      >
                        {new Date(review.created_at).toLocaleDateString()}
                      </a>
                    </li>
                  );
                })}
              </ul>
            ) : (
              <p>None yet</p>
            )}
          </div>
        </div>
      )}

      <ShowMetadata show={yourSeason.show} />
    </div>
  );
};
