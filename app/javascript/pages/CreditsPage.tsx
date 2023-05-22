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
          </a>{" "}
          who have an excellent free API.
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
          . Feel free to pitch in and/or roast me.
        </li>
        <li>
          The television icon you see up top is{" "}
          <a href="https://shannonethomas.com">by Shannon E Thomas</a>, which I got from the now
          defunct <a href="https://www.toicon.com/icons/avocado_watch">to icon</a> project.
        </li>
      </ul>
    </div>
  )
}
