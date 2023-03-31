import { Show } from "../types"

export const ShowMetadata = ({ show }: { show: Show }) => {
  return (
    <div className="my-4 border-b border-t border-solid border-orange-200 py-4">
      <h2 className="text-lg">FYI</h2>
      <ul className="list-inside list-disc">
        {show.tmdb_last_refreshed_at && (
          <li>
            <span className="font-bold">Data last refreshed at:</span>{" "}
            <span title={show.tmdb_last_refreshed_at}>
              {new Date(show.tmdb_last_refreshed_at).toLocaleString()}
            </span>
          </li>
        )}
        {show.tmdb_next_refresh_at && (
          <li>
            <span className="font-bold">Data will next be refreshed within 24 hours of</span>{" "}
            <span title={show.tmdb_next_refresh_at}>
              {new Date(show.tmdb_next_refresh_at).toLocaleDateString()}
            </span>
          </li>
        )}
      </ul>
    </div>
  )
}
