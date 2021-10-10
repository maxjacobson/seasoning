import React, { FunctionComponent } from "react"

import { Show, YourRelationshipToShow, YourShow } from "../types"

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
    return <button disabled={true}>Added</button>
  } else {
    return (
      <button
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
      </button>
    )
  }
}
