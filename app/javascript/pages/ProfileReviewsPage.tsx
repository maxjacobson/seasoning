import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"

import { Guest, SeasonReview, Show } from "../types"
import { setHeadTitle, loadData } from "../hooks"
import { SeasonReviewSummary } from "../components/SeasonReviewSummary"

interface Props extends RouteComponentProps {
  handle?: string
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const ProfileReviewsPage: FunctionComponent<Props> = ({
  guest,
  handle,
  setLoading,
}: Props) => {
  setHeadTitle(`${handle}'s reviews`)

  const reviewsData = loadData<{ reviews: { review: SeasonReview; show: Show }[] }>(
    guest,
    `/api/profiles/${handle}/season-reviews.json`,
    [],
    setLoading
  )

  if (reviewsData.loading) {
    return <div>Loading...</div>
  }

  if (!reviewsData.data) {
    return <div>Not found</div>
  }

  if (reviewsData.data.reviews.length === 0) {
    return (
      <>
        <div>
          <p>No reviews yet!</p>
        </div>
      </>
    )
  }

  return (
    <div>
      {reviewsData.data.reviews.map(({ review, show }) => {
        return <SeasonReviewSummary review={review} show={show} key={review.id} />
      })}
    </div>
  )
}
