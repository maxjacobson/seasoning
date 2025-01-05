import { Link, useSearchParams } from "react-router";
import { FunctionComponent } from "react";
import { setHeadTitle } from "../hooks";
import { Show } from "../types";
interface Props {
  searchResults: Show[] | null;
}

const Year = ({ date: str }: { date: string }) => {
  const date = new Date(str);

  return <>({date.getFullYear()})</>;
};

export const SearchResultsPage: FunctionComponent<Props> = ({ searchResults }) => {
  setHeadTitle("Search results");

  const [searchParams] = useSearchParams();
  const searchQuery = searchParams.get("q");

  const importParams = new URLSearchParams();

  if (searchQuery) {
    importParams.set("q", searchQuery);
  }

  return (
    <>
      <h1 className="text-2xl">Search results</h1>
      {searchResults === null ? (
        <p>No results. Try searching something else.</p>
      ) : (
        <ul className="list-inside list-disc">
          {searchResults.map((show) => (
            <li key={show.id}>
              <Link to={`/shows/${show.slug}`}>
                {show.title} {show.first_air_date && <Year date={show.first_air_date} />}
              </Link>
            </li>
          ))}
        </ul>
      )}
      <p>
        Not seeing what you&rsquo;re looking for? You might be the first person to want to add it.
        Feel free to{" "}
        <Link to={searchQuery ? `/import-show?${importParams.toString()}` : "/import-show"}>
          import it here
        </Link>
        .
      </p>
    </>
  );
};
