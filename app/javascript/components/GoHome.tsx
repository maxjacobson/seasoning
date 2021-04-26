import React, { FunctionComponent } from "react"
import { Link } from "@shopify/polaris"

export const GoHome: FunctionComponent<Record<string, never>> = () => {
  return (
    <>
      <p>
        <Link url="/">Go home</Link>
      </p>
    </>
  )
}
