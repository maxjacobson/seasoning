import React, { useState, FunctionComponent, useEffect } from "react"
import { Link, FormLayout, TextField, Modal, Checkbox, Select, InlineError } from "@shopify/polaris"
import { StarFilledMinor, StarOutlineMinor, CircleDisableMinor } from "@shopify/polaris-icons"
import {
  Show,
  Season,
  SeasonReview,
  AuthenticatedGuest,
  Visibility,
  HumanSettings,
  Rating,
} from "../types"
import { navigate } from "@reach/router"

interface Props {
  guest: AuthenticatedGuest
  globalSetLoading: (loadingState: boolean) => void
  onClose: () => void
  show: Show
  season: Season
}

const RatingChoice = ({
  position,
  setTentativeRating,
  setChoice,
  tentativeRating,
  choice,
}: {
  position: Rating
  setTentativeRating: (_: Rating | undefined) => void
  setChoice: (_: Rating | undefined) => void
  tentativeRating: Rating | undefined
  choice: Rating | undefined
}) => {
  if ((choice && choice >= position) || (tentativeRating && tentativeRating >= position)) {
    return (
      <StarFilledMinor
        width="20"
        onMouseEnter={() => setTentativeRating(position)}
        onMouseLeave={() => setTentativeRating(undefined)}
        cursor="pointer"
        onClick={() => setChoice(position)}
        fill="#FFD700"
      />
    )
  } else {
    return (
      <StarOutlineMinor
        width="20"
        onMouseEnter={() => setTentativeRating(position)}
        onMouseLeave={() => setTentativeRating(undefined)}
        cursor="pointer"
        onClick={() => setChoice(position)}
      />
    )
  }
}

const RatingPicker = ({
  rating,
  setRating,
}: {
  rating: Rating | undefined
  setRating: (_: Rating | undefined) => void
}) => {
  const [tentativeRating, setTentativeRating] = useState<Rating | undefined>(undefined)

  const choiceProps = {
    setTentativeRating: setTentativeRating,
    tentativeRating: tentativeRating,
    choice: rating,
    setChoice: setRating,
  }

  return (
    <>
      <div>
        <RatingChoice position={1} {...choiceProps} />
        <RatingChoice position={2} {...choiceProps} />
        <RatingChoice position={3} {...choiceProps} />
        <RatingChoice position={4} {...choiceProps} />
        <RatingChoice position={5} {...choiceProps} />
        <RatingChoice position={6} {...choiceProps} />
        <RatingChoice position={7} {...choiceProps} />
        <RatingChoice position={8} {...choiceProps} />
        <RatingChoice position={9} {...choiceProps} />
        <RatingChoice position={10} {...choiceProps} />
        <CircleDisableMinor
          width="20"
          cursor="pointer"
          onClick={() => {
            setRating(undefined)
          }}
          onMouseEnter={() => setTentativeRating(undefined)}
          onMouseLeave={() => setTentativeRating(undefined)}
        />
      </div>
      <div>{rating ? `Rating: ${rating}` : "No rating"}</div>
    </>
  )
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
  const [rating, setRating] = useState<Rating | undefined>(undefined)
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
          <RatingPicker rating={rating} setRating={setRating} />

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
