import { GuestContext, SetLoadingContext } from "../contexts";
import { Import, Show } from "../types";
import { useContext, useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router";
import { Button } from "../components/Button";
import queryString from "query-string";
import { TextField } from "../components/TextField";

export const ImportShowPage = () => {
  const [searchParams] = useSearchParams();
  const searchQuery = searchParams.get("q");
  const [showQuery, setShowQuery] = useState(searchQuery || "");
  const [searching, setSearching] = useState(false);
  const [importing, setImporting] = useState(false);
  const [results, setResults] = useState<Import[] | null>(null);
  const navigate = useNavigate();
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);

  const search = async () => {
    if (!guest.authenticated) {
      return;
    }

    setLoading(true);
    setSearching(true);

    const response = await fetch(
      `/api/imports.json?${queryString.stringify({ query: showQuery })}`,
      {
        headers: {
          "X-SEASONING-TOKEN": guest.token,
          "Content-Type": "application/json",
        },
      },
    );

    setLoading(false);
    setSearching(false);

    if (response.ok) {
      const data = (await response.json()) as { shows: Import[] };
      setResults(data.shows);
    } else {
      throw new Error("failed to search");
    }
  };

  useEffect(() => {
    (async () => {
      await search();
    })();
  }, [searchQuery]);

  if (!guest.authenticated) {
    return <div>Not found...</div>;
  }

  return (
    <>
      <h1 className="text-2xl">Import show</h1>

      <p>
        Seasoning is very new. I&rsquo;m sorry to be the one to tell you, but you&rsquo;re an early
        adopter. As such, I&rsquo;m relying on you to help populate our database with interesting
        shows, which will benefit everyone.
      </p>

      <form
        onSubmit={async (event) => {
          event.preventDefault();

          await search();
        }}
      >
        <div>
          <label className="text-lg">Name of show</label>
        </div>
        <div className="mb-2">
          <TextField value={showQuery} onChange={(event) => setShowQuery(event.target.value)} />
        </div>
        <Button type="submit" disabled={searching}>
          Search
        </Button>
      </form>

      {results && (
        <div>
          {results.map((result) => (
            <div
              className="mx-0 my-2 rounded-md border border-dotted border-blue-500 p-1"
              key={result.id}
            >
              {result.poster_url && (
                <img
                  className="border-2 border-solid border-yellow-700 p-1"
                  src={result.poster_url}
                />
              )}
              <div>
                {result.name} {result.year && `(${result.year})`}
              </div>
              <div>
                <Button
                  disabled={importing}
                  onClick={async () => {
                    setLoading(true);
                    setImporting(true);

                    const response = await fetch(`/api/imports.json`, {
                      headers: {
                        "X-SEASONING-TOKEN": guest.token,
                        "Content-Type": "application/json",
                      },
                      method: "POST",
                      body: JSON.stringify({
                        imports: {
                          id: result.id,
                        },
                      }),
                    });

                    setLoading(false);
                    setImporting(false);

                    if (response.ok) {
                      const data = (await response.json()) as { show: Show };
                      await navigate(`/shows/${data.show.slug}`);
                    } else {
                      throw new Error("could not import show");
                    }
                  }}
                >
                  Import
                </Button>
              </div>
            </div>
          ))}
        </div>
      )}
    </>
  );
};
