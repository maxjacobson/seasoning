import React, { FunctionComponent, useState } from "react"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"
import styled from "styled-components"

import { Show, YourRelationshipToShow } from "../types"
import { csrfToken } from "../networking/csrf"

const Container = styled.div`
  background-color: #fff9e8;
  border: 1px dotted black;
  padding 2px;
`

const Editor = styled.textarea`
  width: 100%;
  min-height: 200px;
`

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
      <Container>
        <p>
          Add a note to self about this show. Put whatever you want in here. It&rsquo;s just for
          you. Feel free to use Markdown.
        </p>
        <Editor
          value={newNoteToSelf}
          onChange={(e) => {
            setNewNoteToSelf(e.target.value)
          }}
          disabled={loading}
        />
        <button
          disabled={loading}
          onClick={async (e) => {
            e.preventDefault()
            setLoading(true)

            const response = await fetch(`/api/your-shows/${show.slug}.json`, {
              method: "PATCH",
              headers: {
                "X-CSRF-Token": csrfToken(),
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
        </button>{" "}
        <button
          onClick={(e) => {
            e.preventDefault()
            setIsEditing(false)
          }}
          disabled={loading}
        >
          Cancel
        </button>
        <p>
          <em>
            Tip: I like to use this box to remind myself why I&rsquo;m adding this show. Like,
            I&rsquo;ll make a note of who recommended it to me, and include some links to articles
            that piqued my interest.
          </em>
        </p>
      </Container>
    )
  }

  const edit = (
    <a
      href="#"
      onClick={(e) => {
        e.preventDefault()
        setIsEditing(true)
      }}
    >
      Edit
    </a>
  )

  return (
    <Container>
      {persistedNoteToSelf ? (
        <>
          <div>Only you can see this note to self. {edit}</div>
          <ReactMarkdown plugins={[gfm]}>{persistedNoteToSelf}</ReactMarkdown>
        </>
      ) : (
        <p>
          <em>No note to self.</em> {edit}
        </p>
      )}
    </Container>
  )
}

export default NoteToSelf
