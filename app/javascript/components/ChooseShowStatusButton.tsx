import React, { FunctionComponent, useState } from "react"
import { Popover, Button, ActionList, Icon } from "@shopify/polaris"
import { TickSmallMinor } from "@shopify/polaris-icons"

import { MyShowStatus, Show, YourRelationshipToShow, YourShow } from "../types"
import { displayMyShowStatus, updateMyShow } from "../helpers/my_shows"

const allStatuses: MyShowStatus[] = [
  "might_watch",
  "currently_watching",
  "stopped_watching",
  "waiting_for_more",
  "finished",
]

interface Props {
  show: Show
  yourRelationship: YourRelationshipToShow
  token: string
  globalSetLoading: (loadingState: boolean) => void
  setYourShow: (yourShow: YourShow) => void
}

export const ChooseShowStatusButton: FunctionComponent<Props> = ({
  show,
  token,
  yourRelationship,
  globalSetLoading,
  setYourShow,
}: Props) => {
  const [active, setActive] = useState(false)

  return (
    <Popover
      active={active}
      activator={
        <Button disclosure onClick={() => setActive(true)}>
          {displayMyShowStatus(yourRelationship.status)}
        </Button>
      }
      onClose={() => {
        setActive(false)
      }}
    >
      <ActionList
        items={allStatuses.map((status) => {
          return {
            content: displayMyShowStatus(status),
            onAction: async () => {
              globalSetLoading(true)
              const response = await updateMyShow(show, token, { show: { status: status } })
              globalSetLoading(false)

              if (response.ok) {
                const data: YourShow = await response.json()
                setYourShow(data)
                setActive(false)
              } else {
                throw new Error("Could not update status of show")
              }
            },
            suffix: status == yourRelationship.status && <Icon source={TickSmallMinor} />,
          }
        })}
      />
    </Popover>
  )
}
