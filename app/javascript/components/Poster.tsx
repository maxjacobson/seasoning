import React, { FunctionComponent } from "react"
import { Show } from "../types"

interface Props {
  url: string | null
  show: Show
  size: "small" | "large"
}

export const Poster: FunctionComponent<Props> = ({ url, show, size }: Props) => (
  <>
    {url && <img src={url} alt={`${show.title} poster`} width={size === "small" ? "100" : "185"} />}
  </>
)
