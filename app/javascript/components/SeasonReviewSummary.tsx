import React, { FunctionComponent } from "react"
import { Card, Link } from "@shopify/polaris"

import { SeasonReview, Show } from "../types"
import { ShowPoster } from "../components/ShowPoster"
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
    <Card title={<Link url={url}>Review by {review.author.handle}</Link>} sectioned>
      <Card.Section
        title={
          <>
            {show.title} &mdash; {review.season.name}
          </>
        }
        actions={[
          {
            content: "Read",
            url: url,
          },
        ]}
      >
        <ShowPoster show={show} size="small" />
        <div>{review.rating ? <StarRating rating={review.rating} /> : <>No rating</>}</div>
      </Card.Section>
    </Card>
  )
}
