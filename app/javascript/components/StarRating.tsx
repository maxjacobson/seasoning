import React, { FunctionComponent } from "react"
import styled from "@emotion/styled"

interface Props {
  rating: number
}

const Container = styled.span`
  font-size: 2rem;
`

export const StarRating: FunctionComponent<Props> = ({ rating }) => {
  return (
    <Container title={`${rating}/10 rating`}>
      <Star position={1} rating={rating} />
      <Star position={2} rating={rating} />
      <Star position={3} rating={rating} />
      <Star position={4} rating={rating} />
      <Star position={5} rating={rating} />
      <Star position={6} rating={rating} />
      <Star position={7} rating={rating} />
      <Star position={8} rating={rating} />
      <Star position={9} rating={rating} />
      <Star position={10} rating={rating} />
    </Container>
  )
}

const Star = ({ position, rating }: { position: number; rating: number }) => {
  if (rating >= position) {
    return <span style={{ color: "#FFD700" }}>★</span>
  } else {
    return <span>☆</span>
  }
}
