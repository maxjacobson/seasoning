import React, { FunctionComponent, useState } from "react"
import { Button, TextField } from "@shopify/polaris"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"
import { Badge } from "@shopify/polaris"

import { Show, YourRelationshipToShow } from "../types"

interface Props {
  show: Show
  yourRelationship: YourRelationshipToShow
  token: string
}

const NoteToSelf: FunctionComponent<Props> = ({ yourRelationship, token, show }: Props) => {
  const [isEditing, setIsEditing] = useState(false)
  const [loading, setLoading] = useState(false)

  const [persistedNoteToSelf, setPersistedNoteToSelf] = useState<string>(
    yourRelationship.note_to_self || ""
  )
  const [newNoteToSelf, setNewNoteToSelf] = useState<string>(yourRelationship.note_to_self || "")

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
            setLoading(true)

            const response = await fetch(`/api/your-shows/${show.slug}.json`, {
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

            if (response.ok) {
              setPersistedNoteToSelf(newNoteToSelf)
              setLoading(false)
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
      {persistedNoteToSelf ? (
        <>
          <Badge status="critical">Private</Badge>
          {edit}
          <ReactMarkdown plugins={[gfm]}>{persistedNoteToSelf}</ReactMarkdown>
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
