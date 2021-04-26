import React, { FunctionComponent, useState } from "react"
import { Button, TextContainer } from "@shopify/polaris"

interface Props {
  spoilers: boolean
  children: React.ReactNode
}

export const Spoilers: FunctionComponent<Props> = ({ spoilers, children }: Props) => {
  const [acknowledged, setAcknowledged] = useState(false)

  if (!spoilers || acknowledged) {
    return <>{children}</>
  } else {
    return (
      <>
        <TextContainer>This review contains spoilers! </TextContainer>
        <div>
          <Button primary onClick={() => setAcknowledged(true)}>
            Show me...
          </Button>
        </div>
      </>
    )
  }
}
