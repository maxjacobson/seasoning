import { FunctionComponent, useContext, useEffect, useState } from "react";

import { Button } from "./Button";
import { Markdown } from "../components/Markdown";
import { SetLoadingContext } from "../contexts";
import { Textarea } from "./Textarea";
import { updateMyShow } from "../helpers/my_shows";
import { YourShow } from "../types";

interface Props {
  yourShow: YourShow;
  token: string;
  updateYourShow: (updatedYourShow: YourShow) => void;
}

export const NoteToSelf: FunctionComponent<Props> = ({
  token,
  yourShow,
  updateYourShow,
}: Props) => {
  const [isEditing, setIsEditing] = useState(false);
  const [loading, setLoading] = useState(false);
  const [newNoteToSelf, setNewNoteToSelf] = useState("");
  const globalSetLoading = useContext(SetLoadingContext);

  // I'll confess I am surprised that this is necessary...
  useEffect(() => {
    setNewNoteToSelf(yourShow.your_relationship?.note_to_self || "");
  }, [yourShow.show.slug]);

  if (yourShow.your_relationship?.note_to_self || isEditing) {
    return (
      <div className="my-4 border-t border-b border-solid border-orange-200 py-4">
        <h1 className="text-2xl">Note to self</h1>

        {isEditing ? (
          <div>
            <label>
              <p>
                Put whatever you want in here. It&rsquo;s just for you. Feel free to use{" "}
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
          </div>
        ) : yourShow.your_relationship?.note_to_self ? (
          <div className="break-words">
            <Markdown markdown={yourShow.your_relationship.note_to_self} />
          </div>
        ) : (
          <p>
            <em>No note to self.</em>
          </p>
        )}

        {isEditing ? (
          <div className="mt-4">
            <Button
              onClick={async () => {
                globalSetLoading(true);
                setLoading(true);

                const response = await updateMyShow(yourShow.show, token, {
                  show: {
                    note_to_self: newNoteToSelf,
                  },
                });

                setLoading(false);
                globalSetLoading(false);

                if (response.ok) {
                  const updated = (await response.json()) as YourShow;
                  updateYourShow(updated);
                  setIsEditing(false);
                } else {
                  throw new Error("Could not update note to self");
                }
              }}
            >
              Save
            </Button>

            <span className="ml-1">
              <Button onClick={() => setIsEditing(false)}>Cancel</Button>
            </span>
          </div>
        ) : (
          <div className="mt-4">
            <Button onClick={() => setIsEditing(true)}>Edit</Button>
          </div>
        )}
      </div>
    );
  } else {
    return <Button onClick={() => setIsEditing(true)}>Write note to self</Button>;
  }
};
