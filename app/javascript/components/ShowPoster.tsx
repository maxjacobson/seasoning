import React, { FunctionComponent } from "react"
import { Show } from "../types"

interface Props {
  show: Show
  size: "small" | "large"
}

export const ShowPoster: FunctionComponent<Props> = ({ show, size }: Props) => (
  <>
    {show.poster_url && (
      <img
        src={show.poster_url}
        alt={`${show.title} poster`}
        width={size === "small" ? "100" : "185"}
      />
    )}
  </>
)
