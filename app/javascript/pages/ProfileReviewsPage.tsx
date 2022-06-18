import React, { useContext } from "react"
import { useParams } from "react-router-dom"

import { SeasonReview, Show } from "../types"
import { loadData, setHeadTitle } from "../hooks"
import { SeasonReviewSummary } from "../components/SeasonReviewSummary"
import { GuestContext, SetLoadingContext } from "../contexts"

export const ProfileReviewsPage = () => {
  const guest = useContext(GuestContext)
  const setLoading = useContext(SetLoadingContext)
  const { handle } = useParams()
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
