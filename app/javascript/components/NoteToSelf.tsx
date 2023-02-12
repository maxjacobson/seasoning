import { FunctionComponent, useContext, useEffect, useState } from "react"

import { Button } from "./Button"
import { Markdown } from "../components/Markdown"
import { SetLoadingContext } from "../contexts"
import { Textarea } from "./Textarea"
import { updateMyShow } from "../helpers/my_shows"
import { YourShow } from "../types"

interface Props {
  yourShow: YourShow
  token: string
  updateYourShow: (updatedYourShow: YourShow) => void
}

export const NoteToSelf: FunctionComponent<Props> = ({
  token,
  yourShow,
  updateYourShow,
}: Props) => {
  const [isEditing, setIsEditing] = useState(false)
  const [loading, setLoading] = useState(false)
  const [newNoteToSelf, setNewNoteToSelf] = useState("")
  const globalSetLoading = useContext(SetLoadingContext)

  // I'll confess I am surprised that this is necessary...
  useEffect(() => {
    setNewNoteToSelf(yourShow.your_relationship?.note_to_self || "")
  }, [yourShow.show.slug])

  return (
    <div className="border border-solid border-black p-2">
      <h1 className="text-2xl">Write a note to self</h1>

      {isEditing ? (
        <div>
          <label>
            <p>
              Add a note to self about this show. Put whatever you want in here. It&rsquo;s just for
              you. Feel free to use{" "}
              <a href="https://commonmark.org/help/" target="_blank" rel="noreferrer">
                Markdown
              </a>
              .
            </p>
          </label>

          <Textarea
            disabled={loading}
            value={newNoteToSelf}
            onChange={(event) => setNewNoteToSelf(event.target.value)}
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

      {isEditing ? (
        <>
          <Button
            onClick={async () => {
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
            }}
          >
            Save
          </Button>

          <span className="ml-1">
            <Button onClick={() => setIsEditing(false)}>Cancel</Button>
          </span>
        </>
      ) : (
        <Button onClick={() => setIsEditing(true)}>Edit</Button>
      )}
    </div>
  )
}
