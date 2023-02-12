import { FunctionComponent } from "react"
import { setHeadTitle } from "../hooks"

export const CreditsPage: FunctionComponent = () => {
  setHeadTitle("Credits")

  return (
    <div>
      <h1 className="text-2xl">Credits</h1>

      <ul className="list-inside list-disc">
        <li>
          Obviously this is very much inspired by{" "}
          <a href="https://letterboxd.com/" target="_blank" rel="noreferrer">
            Letterboxd
          </a>
          .
        </li>
        <li>
          All of the data is sourced from{" "}
          <a href="https://www.themoviedb.org/" target="_blank" rel="noreferrer">
            The Movie Database
          </a>
        </li>
        <li>
          This site is developed by{" "}
          <a href="https://www.hardscrabble.net" target="_blank" rel="noreferrer">
            Max Jacobson
          </a>
          . The source code is on GitHub at{" "}
          <a href="https://github.com/maxjacobson/seasoning" target="_blank" rel="noreferrer">
            maxjacobson/seasoning
          </a>
          . Feel free to pitch in and/or roast me. There are no tests. Just going to get ahead of
          that one. Otherwise it&rsquo;s perfect.
        </li>
        <li>
          The television icon you see up top is{" "}
          <a href="https://www.toicon.com/icons/avocado_watch">by Shannon E Thomas</a>.
        </li>
      </ul>
    </div>
  )
}
