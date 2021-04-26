import React, { FunctionComponent, useEffect, useState } from "react"
import { TextField, CalloutCard, Link } from "@shopify/polaris"

import { Markdown } from "../components/Markdown"
import Say from "../images/say.svg"
import { YourShow } from "../types"
import { updateMyShow } from "../helpers/my_shows"

interface Props {
  yourShow: YourShow
  token: string
  globalSetLoading: (loadingState: boolean) => void
  updateYourShow: (updatedYourShow: YourShow) => void
}

export const NoteToSelf: FunctionComponent<Props> = ({
  token,
  yourShow,
  globalSetLoading,
  updateYourShow,
}: Props) => {
  const [isEditing, setIsEditing] = useState(false)
  const [loading, setLoading] = useState(false)

  const [newNoteToSelf, setNewNoteToSelf] = useState("")

  // I'll confess I am surprised that this is necessary...
  useEffect(() => {
    setNewNoteToSelf(yourShow.your_relationship?.note_to_self || "")
  }, [yourShow.show.slug])

  return (
    <CalloutCard
      title="Write a note to self"
      illustration={Say}
      primaryAction={
        isEditing
          ? {
              content: "Save",
              onAction: async () => {
                globalSetLoading(true)
                setLoading(true)

                const response = await updateMyShow(yourShow.show, token, {
                  show: {
                    note_to_self: newNoteToSelf,
                  },
                })

                setLoading(false)
                globalSetLoading(false)

                if (response.ok) {
                  const updated: YourShow = await response.json()
                  updateYourShow(updated)
                  setIsEditing(false)
                } else {
                  throw new Error("Could not update note to self")
                }
              },
            }
          : {
              content: "Edit",
              onAction: () => {
                setIsEditing(true)
              },
            }
      }
      secondaryAction={
        isEditing
          ? {
              content: "Cancel",
              onAction: () => {
                setIsEditing(false)
              },
            }
          : undefined
      }
    >
      {isEditing ? (
        <div>
          <TextField
            label={
              <p>
                Add a note to self about this show. Put whatever you want in here. It&rsquo;s just
                for you. Feel free to use{" "}
                <Link url="https://commonmark.org/help/" external={true}>
                  Markdown
                </Link>
                .
              </p>
            }
            value={newNoteToSelf}
            onChange={setNewNoteToSelf}
            disabled={loading}
            multiline={4}
            clearButton={true}
            onClearButtonClick={() => setNewNoteToSelf("")}
          />
          <p>
            <em>
              Tip: I like to use this box to remind myself why I&rsquo;m adding this show. Like,
              I&rsquo;ll make a note of who recommended it to me, and include some links to articles
              that piqued my interest.
            </em>
          </p>
        </div>
      ) : yourShow.your_relationship?.note_to_self ? (
        <>
          <Markdown markdown={yourShow.your_relationship.note_to_self} />
        </>
      ) : (
        <p>
          <em>No note to self.</em>
        </p>
      )}
    </CalloutCard>
  )
}
