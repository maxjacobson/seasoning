import { displayMyShowStatus, updateMyShow } from "../helpers/my_shows"
import { FunctionComponent, useContext } from "react"
import { MyShowStatus, Show, YourRelationshipToShow, YourShow } from "../types"
import { Select } from "./Select"
import { SetLoadingContext } from "../contexts"

const allStatuses: MyShowStatus[] = [
  "might_watch",
  "next_up",
  "currently_watching",
  "stopped_watching",
  "waiting_for_more",
  "finished",
]

interface Props {
  show: Show
  yourRelationship: YourRelationshipToShow
  token: string
  setYourShow: (yourShow: YourShow) => void
}

export const ChooseShowStatusButton: FunctionComponent<Props> = ({
  show,
  token,
  yourRelationship,
  setYourShow,
}: Props) => {
  const globalSetLoading = useContext(SetLoadingContext)

  return (
    <Select
      value={yourRelationship.status}
      onChange={async (event) => {
        globalSetLoading(true)
        const response = await updateMyShow(show, token, { show: { status: event.target.value } })
        globalSetLoading(false)

        if (response.ok) {
          const data: YourShow = await response.json()
          setYourShow(data)
        } else {
          throw new Error("Could not update status of show")
        }
      }}
    >
      {allStatuses.map((status) => {
        return (
          <option key={status} value={status}>
            {displayMyShowStatus(status)}
          </option>
        )
      })}
    </Select>
  )
}
