import { GuestContext, SetLoadingContext } from "../contexts"
import { loadData, setHeadTitle } from "../hooks"
import { SeasonReview, Show } from "../types"
import { SeasonReviewSummary } from "../components/SeasonReviewSummary"
import { useContext } from "react"
import { useParams } from "react-router-dom"

export const ProfileReviewsPage = () => {
  const guest = useContext(GuestContext)
  const setLoading = useContext(SetLoadingContext)
  const { handle } = useParams()
  setHeadTitle(`${handle}'s reviews`)

  const reviewsData = loadData<{ reviews: { review: SeasonReview; show: Show }[] }>(
    guest,
    `/api/profiles/${handle}/season-reviews.json`,
    [],
    setLoading,
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
          <h1 className="text-2xl">{handle}&rsquo;s reviews</h1>
          <p>No reviews yet!</p>
        </div>
      </>
    )
  }

  return (
    <div>
      <h1 className="text-2xl">{handle}&rsquo;s reviews</h1>
      {reviewsData.data.reviews.map(({ review, show }) => {
        return <SeasonReviewSummary review={review} show={show} key={review.id} />
      })}
      <p>
        <strong>Note:</strong> this is just the 10 most recent reviews!
      </p>
    </div>
  )
}
