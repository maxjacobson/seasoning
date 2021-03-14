import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"

import { setHeadTitle } from "../hooks"

const About: FunctionComponent<RouteComponentProps> = (
  _props: RouteComponentProps
) => {
  setHeadTitle("About")

  return (
    <>
      <h2>About</h2>
      <p>
        This is <strong>Seasoning</strong>. It&rsquo;s a simple website to help
        you survive the age of <em>Peak TV</em>.
      </p>
      <p>
        Did your coworker recommend some show that will totally change your
        life? Don&rsquo;t stress. Jot it down, make a note of it, and get back
        to your life. Then next time you&rsquo;re bored off your gourd, check
        back in.
      </p>
      <p>
        &mdash;{" "}
        <a
          href="https://twitter.com/maxjacobson"
          target="_blank"
          rel="noopener noreferrer"
        >
          Max
        </a>
      </p>
    </>
  )
}
export default About
