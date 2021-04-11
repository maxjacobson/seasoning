import React, { useState, FunctionComponent } from "react"
import { FormLayout, TextField, Modal, Checkbox, Select, InlineError } from "@shopify/polaris"

import { Show, Season, SeasonReview, AuthenticatedGuest } from "../types"
import { navigate } from "@reach/router"

interface Props {
  guest: AuthenticatedGuest
  globalSetLoading: (loadingState: boolean) => void
  onClose: () => void
  show: Show
  season: Season
}

const NewSeasonReviewModal: FunctionComponent<Props> = ({
  guest,
  globalSetLoading,
  onClose,
  show,
  season,
}: Props) => {
  const [active, setActive] = useState(true)
  const [body, setBody] = useState("")
  const [visibility, setVisibility] = useState("anybody")
  const [containsSpoilers, setContainsSpoilers] = useState(false)
  const [rating, setRating] = useState("")
  const [validationError, setValidationError] = useState<null | Record<string, string[]>>(null)

  return (
    <Modal
      open={active}
      title="New review"
      onClose={() => {
        setActive(false)
        onClose()
      }}
      primaryAction={{
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
            onChange={setVisibility}
            value={visibility}
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
            label="Your review (you can use markdown)"
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

export default NewSeasonReviewModal
