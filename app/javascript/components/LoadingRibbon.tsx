import React, { FunctionComponent } from "react"
import styled from "@emotion/styled"

interface Props {
  loading: boolean
}

const Ribbon = styled.div`
  background-color: grey;
  width: 100%;
  height: 10px;
  position: absolute;
  top: 0;
  left: 0;
`

export const LoadingRibbon: FunctionComponent<Props> = ({ loading }: Props) => {
  if (loading) {
    return <Ribbon />
  } else {
    return <></>
  }
}
