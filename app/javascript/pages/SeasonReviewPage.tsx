import React, { FunctionComponent, useState, useEffect } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, Card, SkeletonPage, Layout, SkeletonBodyText } from "@shopify/polaris"
import querystring from "query-string"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"
import { DateTime } from "luxon"

import Spoilers from "../components/Spoilers"
import { Guest, Season, SeasonReview, Show } from "../types"

interface LoadingReviewData {
  loading: true
}

interface LoadedReviewData {
  loading: false
  review: SeasonReview
  show: Show
  season: Season
}

interface ReviewDataNotFound {
  loading: false
  review: null
  season: null
  show: null
}
type SeasonReviewData = LoadingReviewData | LoadedReviewData | ReviewDataNotFound

interface Props extends RouteComponentProps {
  handle?: string
  showSlug?: string
  seasonSlug?: string
  viewing?: string
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

const SeasonReviewPage: FunctionComponent<Props> = ({
  handle,
  showSlug,
  seasonSlug,
  viewing,
  setLoading,
  guest,
}: Props) => {
  const [reviewData, setReviewData] = useState<SeasonReviewData>({ loading: true })

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
        `/api/season-review.json?${querystring.stringify({
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
        const data: { review: SeasonReview; show: Show; season: Season } = await response.json()
        setReviewData({ loading: false, review: data.review, show: data.show, season: data.season })
      } else if (response.status === 404) {
        setReviewData({ loading: false, review: null, season: null, show: null })
      } else {
        throw new Error("Could not load review")
      }
    })()
  }, [handle, showSlug, seasonSlug, viewing])

  if (reviewData.loading) {
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

  if (!reviewData.review) {
    return (
      <Page title="Not found" breadcrumbs={[{ url: `/${handle}` }]}>
        <Card sectioned>
          <Card.Section>
            <p>Review not found!</p>
          </Card.Section>
        </Card>
      </Page>
    )
  }

  const { review, show, season } = reviewData

  return (
    <Page
      title={show.title}
      subtitle={season.name}
      breadcrumbs={[{ url: `/shows/${showSlug}/${seasonSlug}` }]}
    >
      <Card sectioned title={`${handle}'s review`}>
        <Card.Section title="Date">
          {DateTime.fromISO(review.created_at).toLocaleString()}
        </Card.Section>
        <Card.Section title="Rating">{review.rating}</Card.Section>
        <Card.Section>
          <Spoilers spoilers={review.spoilers}>
            <ReactMarkdown plugins={[gfm]}>{review.body}</ReactMarkdown>
          </Spoilers>
        </Card.Section>
      </Card>
    </Page>
  )
}

export default SeasonReviewPage
