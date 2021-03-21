import React, { FunctionComponent, useEffect, useState } from "react"
import { Button, TextField } from "@shopify/polaris"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"
import { Badge } from "@shopify/polaris"

import { YourShow } from "../types"

interface Props {
  yourShow: YourShow
  token: string
  globalSetLoading: (loadingState: boolean) => void
  updateYourShow: (updatedYourShow: YourShow) => void
}

const NoteToSelf: FunctionComponent<Props> = ({
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

  if (isEditing) {
    return (
      <div>
        <TextField
          label={
            <p>
              Add a note to self about this show. Put whatever you want in here. It&rsquo;s just for
              you. Feel free to use Markdown.
            </p>
          }
          value={newNoteToSelf}
          onChange={setNewNoteToSelf}
          disabled={loading}
          multiline={4}
          clearButton={true}
          onClearButtonClick={() => setNewNoteToSelf("")}
        />
        <Button
          disabled={loading}
          onClick={async () => {
            globalSetLoading(true)
            setLoading(true)

            const response = await fetch(`/api/your-shows/${yourShow.show.slug}.json`, {
              method: "PATCH",
              headers: {
                "X-SEASONING-TOKEN": token,
                "Content-Type": "application/json",
              },
              body: JSON.stringify({
                show: {
                  note_to_self: newNoteToSelf,
                },
              }),
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
          }}
        >
          Save
        </Button>{" "}
        <Button
          onClick={() => {
            setIsEditing(false)
          }}
          disabled={loading}
        >
          Cancel
        </Button>
        <p>
          <em>
            Tip: I like to use this box to remind myself why I&rsquo;m adding this show. Like,
            I&rsquo;ll make a note of who recommended it to me, and include some links to articles
            that piqued my interest.
          </em>
        </p>
      </div>
    )
  }

  const edit = (
    <Button
      onClick={() => {
        setIsEditing(true)
      }}
    >
      Edit
    </Button>
  )

  return (
    <>
      {yourShow.your_relationship?.note_to_self ? (
        <>
          <Badge status="critical">Private</Badge>
          {edit}
          <ReactMarkdown plugins={[gfm]}>{yourShow.your_relationship?.note_to_self}</ReactMarkdown>
        </>
      ) : (
        <p>
          <em>No note to self.</em> {edit}
        </p>
      )}
    </>
  )
}

export default NoteToSelf
