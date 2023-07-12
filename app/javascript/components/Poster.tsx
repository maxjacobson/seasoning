import { FunctionComponent } from "react";
import { Show } from "../types";

interface Props {
  url: string | null;
  show: Show;
  size: "small" | "large";
}

export const Poster: FunctionComponent<Props> = ({ url, show, size }: Props) => (
  <>
    {url && (
      <img
        className="border-2 border-solid border-yellow-700 p-1"
        src={url}
        alt={`${show.title} poster`}
        width={size === "small" ? "100" : "185"}
      />
    )}
  </>
);
