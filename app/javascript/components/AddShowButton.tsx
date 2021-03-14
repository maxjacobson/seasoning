import React, { useEffect, useState } from "react"

import { Show, YourShow } from "../types"
import { csrfToken } from "../networking/csrf"

type Availability =
  | { loading: true; yourShow: null }
  | { loading: false; yourShow: YourShow }

const AddShowButton = ({ show, token }: { show: Show; token: string }) => {
  const [availability, setAvailability] = useState<Availability>({
    loading: true,
    yourShow: null,
  })

  useEffect(() => {
    ;(async () => {
      const response = await fetch(`/api/your-shows/${show.slug}.json`, {
        headers: {
          "X-SEASONING-TOKEN": token,
        },
      })

      if (response.ok) {
        const data: { your_show: YourShow } = await response.json()
        setAvailability({ loading: false, yourShow: data.your_show })
      } else {
        throw new Error("Could not load my show")
      }
    })()
  }, [])

  if (availability.loading) {
    return <button disabled={true}>...</button>
  }

  if (!availability.yourShow.your_relationship) {
    return (
      <button
        onClick={async (e) => {
          e.preventDefault()

          const response = await fetch(`/api/your-shows.json`, {
            headers: {
              "X-CSRF-Token": csrfToken(),
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
            setAvailability({ loading: false, yourShow: data.your_show })
          } else {
            throw new Error("Could not add show")
          }
        }}
      >
        Add
      </button>
    )
  }

  return <button disabled={true}>Added</button>
}

export default AddShowButton
