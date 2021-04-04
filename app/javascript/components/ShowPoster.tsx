import React, { FunctionComponent } from "react"
import { Show } from "../types"

interface Props {
  show: Show
}

const ShowPoster: FunctionComponent<Props> = ({ show }: Props) => (
  <>{show.poster_url && <img src={show.poster_url} alt={`${show.title} poster`} width="185" />}</>
)

export default ShowPoster
