import React, { FunctionComponent, useState, useEffect } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, Card, SkeletonPage, Layout, SkeletonBodyText } from "@shopify/polaris"

import { SeasonReviewSummary } from "../components/SeasonReviewSummary"
import { Guest, SeasonReview, Show } from "../types"
import { setHeadTitle } from "../hooks"

interface LoadingReviewsFeedData {
  loading: true
}

interface LoadedReviewsFeedData {
  loading: false
  data: {
    show: Show
    review: SeasonReview
  }[]
}

type ReviewsFeedData = LoadingReviewsFeedData | LoadedReviewsFeedData

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const ReviewsFeedPage: FunctionComponent<Props> = ({ setLoading, guest }: Props) => {
  const [feedData, setFeedData] = useState<ReviewsFeedData>({ loading: true })

  useEffect(() => {
    ;(async () => {
      const headers: Record<string, string> = {
        "Content-Type": "application/json",
      }
      if (guest.authenticated) {
        headers["X-SEASONING-TOKEN"] = guest.token
      }

      setLoading(true)
      const response = await fetch("/api/season-reviews.json", {
        headers: headers,
      })
      setLoading(false)

      if (response.ok) {
        const data = await response.json()
        setFeedData({ loading: false, data: data.data })
      } else {
        throw new Error("Could not load reviews")
      }
    })()
  }, [])

  setHeadTitle("Reviews", [feedData])

  if (feedData.loading) {
    return (
      <SkeletonPage>
        <Layout>
          <Layout.Section>
            <Card sectioned>
              <SkeletonBodyText />
            </Card>
          </Layout.Section>
        </Layout>
      </SkeletonPage>
    )
  }

  return (
    <Page title="Reviews">
      <Card sectioned>
        <Card.Section title="Recent">
          {feedData.data.map(({ review, show }) => {
            return <SeasonReviewSummary key={review.id} review={review} show={show} />
          })}
        </Card.Section>
      </Card>
    </Page>
  )
}
