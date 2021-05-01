import React, { FunctionComponent, useState, useEffect } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, Card, SkeletonPage, Layout, SkeletonBodyText, Link } from "@shopify/polaris"
import { stringify } from "query-string"
import { DateTime } from "luxon"

import { Markdown } from "../components/Markdown"
import { Guest, Season, SeasonReview, Show } from "../types"
import { setHeadTitle } from "../hooks"

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

export const SeasonReviewPage: FunctionComponent<Props> = ({
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
        const data: { review: SeasonReview; show: Show; season: Season } = await response.json()
        setReviewData({ loading: false, review: data.review, show: data.show, season: data.season })
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
    <Page title={show.title} subtitle={season.name}>
      <Card
        sectioned
        title={
          <>
            <Link url={`/${handle}`}>{handle}</Link>&rsquo;s review of{" "}
            <Link url={`/shows/${show.slug}/${season.slug}`}>{season.name}</Link> of{" "}
            <Link url={`/shows/${show.slug}`}>{show.title}</Link>.
          </>
        }
      >
        <Card.Section title="Date">
          {DateTime.fromISO(review.created_at).toLocaleString()}
        </Card.Section>
        {review.rating != null && <Card.Section title="Rating">{review.rating}</Card.Section>}
        <Card.Section>
          <Markdown markdown={review.body} />
        </Card.Section>
      </Card>
    </Page>
  )
}
