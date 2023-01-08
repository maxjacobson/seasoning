import React, { FunctionComponent } from "react"

import { setHeadTitle } from "../hooks"

export const CreditsPage: FunctionComponent = () => {
  setHeadTitle("Credits")

  return (
    <div>
      <h1>Credits</h1>

      <div>
        <h2>Inspiration</h2>

        <p>
          Obviously this is very much inspired by{" "}
          <a href="https://letterboxd.com/" target="_blank" rel="noreferrer">
            Letterboxd
          </a>
          .
        </p>
      </div>

      <div>
        <h2>Credits</h2>
        <h3>Data</h3>
        <p>
          All data from{" "}
          <a href="https://www.themoviedb.org/" target="_blank" rel="noreferrer">
            The Movie Database
          </a>
          .
        </p>

        <h3>Development</h3>
        <p>
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
        </p>

        <h3>Icon</h3>
        <p>
          The television icon you see up top is{" "}
          <a href="https://www.toicon.com/icons/avocado_watch">by Shannon E Thomas</a>.
        </p>
      </div>
    </div>
  )
}
