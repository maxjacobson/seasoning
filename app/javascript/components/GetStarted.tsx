import { useContext, useEffect, useState } from "react"
import { Button } from "./Button"
import { SetLoadingContext } from "../contexts"
import { TextField } from "./TextField"

export const GetStarted = () => {
  const [email, setEmail] = useState("")
  const [loading, setLoading] = useState(false)
  const [createdMagicLink, setCreatedMagicLink] = useState(false)
  const globalSetLoading = useContext(SetLoadingContext)

  useEffect(() => {
    if (!loading) {
      return
    }

    globalSetLoading(true)
    fetch("/api/magic-links.json", {
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ magic_link: { email: email } }),
      method: "POST",
    })
      .then((response) => {
        globalSetLoading(false)
        setLoading(false)

        if (response.ok) {
          return response.json()
        } else {
          throw new Error("Could not create magic link")
        }
      })
      .then(() => {
        setCreatedMagicLink(true)
      })
  }, [loading])

  if (createdMagicLink) {
    return (
      <div>
        <h2>Nice!</h2>
        <p>Check your email for a link to log in to Seasoning!</p>
      </div>
    )
  } else {
    return (
      <>
        <div>
          <p>
            This is <strong>Seasoning</strong>. It&rsquo;s a simple website to help you survive the
            age of <em>Peak TV</em>.
          </p>
          <p>
            Did your coworker recommend some show that will totally change your life? Don&rsquo;t
            stress. Jot it down, make a note of it, and get back to your life. Then next time
            you&rsquo;re bored off your gourd, check back in.
          </p>
          <p>
            &mdash;{" "}
            <a href="https://www.hardscrabble.net/" target="_blank" rel="noreferrer">
              Max
            </a>
          </p>
        </div>

        <div>
          <p className="mt-2 mb-2">
            To sign up or log in, just enter your email address and we&rsquo;ll send you a link to
            get started:
          </p>
          <div>
            <form
              onSubmit={(e) => {
                e.preventDefault()
                setLoading(true)
              }}
            >
              <TextField
                placeholder="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                disabled={loading}
              />
              <span className="ml-2">
                <Button type="submit" value="Go" disabled={loading} />
              </span>
            </form>
          </div>

          <div className="mt-2">
            <h1 className="mb-2 text-2xl">Demo (February 14, 2023)</h1>
            <iframe
              width="560"
              height="315"
              src="https://www.youtube-nocookie.com/embed/4aB6LbN2ff8"
              title="YouTube video player"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
              allowFullScreen
            ></iframe>
          </div>
        </div>
      </>
    )
  }
}
