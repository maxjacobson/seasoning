import { AuthenticatedGuest, Season, Show, YourSeason } from "../types";
import { FunctionComponent, useContext, useEffect, useState } from "react";
import { Checkbox } from "./Checkbox";
import { SetLoadingContext } from "../contexts";
import { updateMySeason } from "../helpers/my_shows";

type HasWatched = "unknown" | "partial" | boolean;

interface Props {
  guest: AuthenticatedGuest;
  show: Show;
  season: Season;
}

export const SeenSeasonCheckbox: FunctionComponent<Props> = ({ guest, season, show }) => {
  const [updating, setUpdating] = useState(false);
  const [hasWatched, setHasWatched] = useState<HasWatched>("unknown");
  const setLoading = useContext(SetLoadingContext);

  useEffect(() => {
    (async () => {
      setLoading(true);
      const response = await fetch(`/api/shows/${show.slug}/seasons/${season.slug}.json`, {
        headers: { "X-SEASONING_TOKEN": guest.token },
      });
      setLoading(false);

      if (response.ok) {
        const yourSeason: YourSeason = await response.json();

        const yourRelationship = yourSeason.your_relationship;

        if (yourRelationship) {
          if (yourRelationship.watched_episode_numbers.length === yourSeason.season.episode_count) {
            setHasWatched(true);
          } else if (yourRelationship.watched_episode_numbers.length === 0) {
            setHasWatched(false);
          } else {
            setHasWatched("partial");
          }
        } else {
          setHasWatched(false);
        }
      } else {
        throw new Error("Could not load season");
      }
    })();
  }, []);

  return (
    <>
      <Checkbox
        className="text-yellow-500"
        inputRef={(input) => {
          if (input && hasWatched === "partial") {
            input.indeterminate = true;
          } else if (input) {
            input.indeterminate = false;
          }
        }}
        checked={hasWatched === true}
        disabled={hasWatched === "unknown" || updating}
        onChange={async () => {
          const newHasWatched: boolean = hasWatched === true ? false : true;

          setLoading(true);
          setUpdating(true);
          const response = await updateMySeason(season, guest.token, {
            season: {
              watched: newHasWatched,
            },
          });

          setLoading(false);
          setUpdating(false);

          if (response.ok) {
            setHasWatched(newHasWatched);
          } else {
            throw new Error("Could not toggle watched status");
          }
        }}
      />
    </>
  );
};
