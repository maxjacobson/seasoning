import { Button } from "./Button"
import { Show } from "../types"

interface Props {
  show: Show
  token: string
  onRemove: () => void
}

export const RemoveShowButton = ({ show, token, onRemove }: Props) => {
  return (
    <Button
      onClick={async () => {
        if (
          !confirm(
            "Are you sure? This will lose track of your note to self and show status (but not reviews or which episodes you've seen"
          )
        ) {
          return
        }

        // N.B. here we're specifying the show id rather than the my_shows id, because that's what we've expoed to the front-end
        // and it's non-ambiguous
        const response = await fetch(`/api/your-shows/${show.slug}.json`, {
          headers: {
            "Content-Type": "application/json",
            "X-SEASONING-TOKEN": token,
          },
          method: "DELETE",
        })

        if (response.ok) {
          onRemove()
        } else {
          throw new Error("Could not remove show")
        }
      }}
    >
      Remove
    </Button>
  )
}
