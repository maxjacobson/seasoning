import React, { FunctionComponent } from "react"
import { SeasonReview, Show } from "../types"
import { Link } from "react-router-dom"
import { Poster } from "./Poster"
import { StarRating } from "../components/StarRating"

interface Props {
  review: SeasonReview
  show: Show
}

export const SeasonReviewSummary: FunctionComponent<Props> = ({ review, show }) => {
  const url = `/${review.author.handle}/shows/${show.slug}/${review.season.slug}${
    review.viewing === 1 ? "" : `/${review.viewing}`
  }`

  return (
    <div>
      <h1 className="text-xl">
        <Link to={url}>Review by {review.author.handle}</Link>
      </h1>
      <div>
        <h2 className="text-lg">
          {show.title} &mdash; {review.season.name}
        </h2>
        <Poster show={show} size="small" url={review.season.poster_url} />
        <div>{review.rating ? <StarRating rating={review.rating} /> : <>No rating</>}</div>
        <div>
          <Link to={url}>Read</Link>
        </div>
      </div>
    </div>
  )
}
