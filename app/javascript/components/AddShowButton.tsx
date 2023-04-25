import { Show, YourRelationshipToShow, YourShow } from "../types"
import { Button } from "./Button"
import { FunctionComponent } from "react"

interface Props {
  show: Show
  yourRelationship?: YourRelationshipToShow
  token: string
  setYourShow: (yourShow: YourShow) => void
}

export const AddShowButton: FunctionComponent<Props> = ({
  show,
  token,
  yourRelationship,
  setYourShow,
}: Props) => {
  if (yourRelationship) {
    return <Button disabled={true}>Added</Button>
  } else {
    return (
      <Button
        onClick={async () => {
          const response = await fetch(`/api/your-shows.json`, {
            headers: {
              "Content-Type": "application/json",
              "X-SEASONING-TOKEN": token,
            },
            body: JSON.stringify({
              show: {
                id: show.id,
              },
            }),
            method: "POST",
          })

          if (response.ok) {
            const data: { your_show: YourShow } = await response.json()
            setYourShow(data.your_show)
          } else {
            throw new Error("Could not add show")
          }
        }}
      >
        Add
      </Button>
    )
  }
}
