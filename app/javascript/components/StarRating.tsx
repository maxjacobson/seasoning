import { FunctionComponent } from "react";

interface Props {
  rating: number;
}

export const StarRating: FunctionComponent<Props> = ({ rating }) => {
  return (
    <span title={`${rating}/10 rating`}>
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
    </span>
  );
};

const Star = ({ position, rating }: { position: number; rating: number }) => {
  if (rating >= position) {
    return <span className="text-yellow-400">★</span>;
  } else {
    return <span>☆</span>;
  }
};
