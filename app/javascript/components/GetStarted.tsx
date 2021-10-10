import React, { useEffect, useState, FunctionComponent } from "react"

interface Props {
  globalSetLoading: (loadingState: boolean) => void
}

export const GetStarted: FunctionComponent<Props> = ({ globalSetLoading }) => {
  const [email, setEmail] = useState("")
  const [loading, setLoading] = useState(false)
  const [createdMagicLink, setCreatedMagicLink] = useState(false)

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
            <a href="https://twitter.com/maxjacobson" target="_blank" rel="noreferrer">
              Max
            </a>
          </p>
        </div>

        <div>
          <p>
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
              <input
                type="text"
                placeholder="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                disabled={loading}
              />
              <input type="submit" value="Go" disabled={loading} />
            </form>
          </div>
        </div>
      </>
    )
  }
}
