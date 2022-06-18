import React, { FunctionComponent, useEffect, useState } from "react"
import { Link, useNavigate, useParams } from "react-router-dom"
import { stringify } from "query-string"

import { Markdown } from "../components/Markdown"
import { Guest, Human, Season, SeasonReview, Show } from "../types"
import { setHeadTitle } from "../hooks"
import { StarRating } from "../components/StarRating"
import { Poster } from "../components/Poster"

interface LoadingReviewData {
  loading: true
}

interface LoadedReviewData {
  loading: false
  review: SeasonReview
  show: Show
  season: Season
  author: Human
}

interface ReviewDataNotFound {
  loading: false
  review: null
  season: null
  show: null
}
type SeasonReviewData = LoadingReviewData | LoadedReviewData | ReviewDataNotFound

interface Props {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const SeasonReviewPage: FunctionComponent<Props> = ({ setLoading, guest }: Props) => {
  const [reviewData, setReviewData] = useState<SeasonReviewData>({ loading: true })
  const { handle, showSlug, seasonSlug, viewing } = useParams()
  const navigate = useNavigate()

  useEffect(() => {
    ;(async () => {
      if (!handle || !showSlug || !seasonSlug) {
        setReviewData({ loading: false, review: null, season: null, show: null })
        return
      }

      setLoading(true)
      const headers: Record<string, string> = {
        "Content-Type": "application/json",
      }
      if (guest.authenticated) {
        headers["X-SEASONING-TOKEN"] = guest.token
      }
      const response = await fetch(
        `/api/season-review.json?${stringify({
          handle: handle,
          show: showSlug,
          season: seasonSlug,
          viewing: viewing,
        })}`,
        {
          headers: headers,
        }
      )
      setLoading(false)

      if (response.ok) {
        const data: { review: SeasonReview; show: Show; season: Season; author: Human } =
          await response.json()
        setReviewData({
          loading: false,
          review: data.review,
          show: data.show,
          season: data.season,
          author: data.author,
        })
      } else if (response.status === 404) {
        setReviewData({ loading: false, review: null, season: null, show: null })
      } else {
        throw new Error("Could not load review")
      }
    })()
  }, [handle, showSlug, seasonSlug, viewing])

  let headTitle
  if (!reviewData.loading && reviewData.review) {
    headTitle = `${reviewData.show.title} - ${reviewData.season.name} Review`
  }
  setHeadTitle(headTitle, [reviewData])

  if (reviewData.loading) {
    return <div>Loading...</div>
  }

  if (!reviewData.review) {
    return (
      <div>
        <h1>Not found</h1>
        <p>Review not found!</p>
        <p>
          <Link to={`/${handle}`}>Back</Link>
        </p>
      </div>
    )
  }

  const { review, show, season } = reviewData

  return (
    <div>
      <h1>{show.title}</h1>
      <h2>{season.name}</h2>

      <div>
        <h3>
          <Link to={`/${handle}`}>{handle}</Link>&rsquo;s review of{" "}
          <Link to={`/shows/${show.slug}/${season.slug}`}>{season.name}</Link> of{" "}
          <Link to={`/shows/${show.slug}`}>{show.title}</Link>.
        </h3>

        <div>
          <h3>Poster</h3>
          <Poster show={show} url={season.poster_url} size="large" />
        </div>

        <div>
          <h3>Date</h3>
          <span>{new Date(review.created_at).toLocaleDateString()}</span>
        </div>

        {review.rating != null && (
          <div>
            <h3>Rating</h3>
            <StarRating rating={review.rating} />
          </div>
        )}
        <div>
          <Markdown markdown={review.body} />
        </div>

        {guest.authenticated && review.author.handle === guest.human.handle && (
          <div>
            <button
              onClick={async (event) => {
                event.preventDefault()

                if (confirm("Are you sure?")) {
                  const headers: Record<string, string> = {
                    "Content-Type": "application/json",
                  }
                  if (guest.authenticated) {
                    headers["X-SEASONING-TOKEN"] = guest.token
                  }
                  const response = await fetch(
                    `/api/season-review.json?${stringify({
                      handle: handle,
                      show: showSlug,
                      season: seasonSlug,
                      viewing: viewing,
                    })}`,
                    {
                      headers: headers,
                      method: "DELETE",
                    }
                  )
                  setLoading(false)

                  if (response.ok) {
                    navigate(`/${handle}`)
                  } else {
                    throw new Error("Could not delete")
                  }
                }
              }}
            >
              Delete review
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
