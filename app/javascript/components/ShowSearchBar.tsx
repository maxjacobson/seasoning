import { AuthenticatedGuest, Show } from "../types";
import { FunctionComponent, useContext, useEffect } from "react";
import { Button } from "./Button";
import debounce from "lodash.debounce";
import { SetLoadingContext } from "../contexts";
import { TextField } from "./TextField";
import { useNavigate } from "react-router";

const searchForShows = (
  title: string,
  token: string,
  setLoading: (loadingState: boolean) => void,
  callback: (shows: Show[] | null) => void,
) => {
  setLoading(true);

  if (!title) {
    callback(null);
    setLoading(false);
    return;
  }

  (async () => {
    const response = await fetch(`/api/shows.json?q=${encodeURIComponent(title)}`, {
      headers: {
        "X-SEASONING-TOKEN": token,
      },
    });

    setLoading(false);
    if (response.ok) {
      const data = (await response.json()) as { shows: Show[] };
      callback(data.shows);
    } else {
      throw new Error("Could not search shows");
    }
  })();
};
const debouncedSearch = debounce(searchForShows, 400, { trailing: true });

interface Props {
  guest: AuthenticatedGuest;
  callback: (results: Show[] | null) => void;
  query: string;
  setQuery: (query: string) => void;
}

export const ShowSearchBar: FunctionComponent<Props> = ({ guest, callback, query, setQuery }) => {
  const navigate = useNavigate();
  const setLoading = useContext(SetLoadingContext);
  useEffect(() => {
    debouncedSearch(query, guest.token, setLoading, callback);
  }, [query]);

  return (
    <form
      className="md:mr-2 md:inline"
      onSubmit={async (event) => {
        event.preventDefault();
        await navigate(`/search?q=${encodeURIComponent(query)}`);
      }}
    >
      <span className="mr-2">
        <TextField
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Search"
        />
      </span>
      <Button type="submit" value="Search" />
    </form>
  );
};
