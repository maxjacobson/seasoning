import React, { useState, FunctionComponent, useEffect } from "react"
import { Link, FormLayout, TextField, Modal, Checkbox, Select, InlineError } from "@shopify/polaris"

import { Show, Season, SeasonReview, AuthenticatedGuest, Visibility, HumanSettings } from "../types"
import { navigate } from "@reach/router"

interface Props {
  guest: AuthenticatedGuest
  globalSetLoading: (loadingState: boolean) => void
  onClose: () => void
  show: Show
  season: Season
}

export const NewSeasonReviewModal: FunctionComponent<Props> = ({
  guest,
  globalSetLoading,
  onClose,
  show,
  season,
}: Props) => {
  const [active, setActive] = useState(true)
  const [body, setBody] = useState("")
  const [visibility, setVisibility] = useState<Visibility | undefined>(undefined)
  const [containsSpoilers, setContainsSpoilers] = useState(false)
  const [rating, setRating] = useState("")
  const [validationError, setValidationError] = useState<null | Record<string, string[]>>(null)

  useEffect(() => {
    ;(async () => {
      globalSetLoading(true)
      const response = await fetch("/api/settings.json", {
        headers: {
          "X-SEASONING-TOKEN": guest.token,
        },
      })
      globalSetLoading(false)

      if (response.ok) {
        const data: HumanSettings = await response.json()
        setVisibility(data.default_review_visibility)
      } else {
        throw new Error("Could not load settings")
      }
    })()
  }, [])

  return (
    <Modal
      open={active}
      title="New review"
      onClose={() => {
        setActive(false)
        onClose()
      }}
      primaryAction={{
        disabled: !visibility,
        content: "Save",
        onAction: async () => {
          globalSetLoading(true)
          const response = await fetch("/api/season-reviews.json", {
            method: "POST",
            headers: {
              "X-SEASONING-TOKEN": guest.token,
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              review: {
                body: body,
                visibility: visibility,
                spoilers: containsSpoilers,
                rating: rating,
              },
              show_id: show.id,
              season_id: season.id,
            }),
          })
          globalSetLoading(false)

          if (response.ok) {
            const data = await response.json()
            const review: SeasonReview = data.review
            const url = `/${guest.human.handle}/shows/${show.slug}/${season.slug}${
              review.viewing === 1 ? "" : `/${review.viewing}`
            }`
            setActive(false)
            onClose()
            navigate(url)
          } else if (response.status === 400) {
            const data = await response.json()
            setValidationError(data)
          } else {
            throw new Error("Could not create review")
          }
        },
      }}
      secondaryActions={[
        {
          content: "Cancel",
          onAction: () => {
            setActive(false)
            onClose()
          },
        },
      ]}
    >
      <Modal.Section>
        <FormLayout>
          <Checkbox
            label="Contains spoilers"
            checked={containsSpoilers}
            onChange={setContainsSpoilers}
          />
          <Select
            label="Visible to"
            labelInline
            options={[
              { label: "Anybody", value: "anybody" },
              { label: "Mutual follows", value: "mutuals" },
              { label: "Only myself", value: "myself" },
            ]}
            onChange={(value: Visibility) => setVisibility(value)}
            value={visibility}
            disabled={!visibility}
          />
          <Select
            label="Rating"
            labelInline
            options={[
              { label: "(None)", value: "" },
              { label: "0/10", value: "0" },
              { label: "1/10", value: "1" },
              { label: "2/10", value: "2" },
              { label: "3/10", value: "3" },
              { label: "4/10", value: "4" },
              { label: "5/10", value: "5" },
              { label: "6/10", value: "6" },
              { label: "7/10", value: "7" },
              { label: "8/10", value: "8" },
              { label: "9/10", value: "9" },
              { label: "10/10", value: "10" },
            ]}
            onChange={setRating}
            value={rating}
          />

          <TextField
            label={
              <span>
                Your review (you can use{" "}
                <Link url="https://commonmark.org/help/" external={true}>
                  Markdown
                </Link>
                )
              </span>
            }
            onChange={setBody}
            value={body}
            multiline={10}
          />

          {validationError &&
            Object.keys(validationError).map((key) => {
              return (
                <>
                  {validationError[key].map((errorMessage, i) => {
                    return <InlineError key={i} message={`${key} ${errorMessage}`} fieldID={key} />
                  })}
                </>
              )
            })}
        </FormLayout>
      </Modal.Section>
    </Modal>
  )
}
