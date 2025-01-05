import { GuestContext, SetLoadingContext } from "../contexts";
import { SeasonReview, Show } from "../types";
import { useContext, useEffect, useState } from "react";
import { Navigate } from "react-router";
import { SeasonReviewSummary } from "../components/SeasonReviewSummary";
import { setHeadTitle } from "../hooks";

interface LoadingReviewsFeedData {
  loading: true;
}

interface LoadedReviewsFeedData {
  loading: false;
  data: {
    show: Show;
    review: SeasonReview;
  }[];
}

type ReviewsFeedData = LoadingReviewsFeedData | LoadedReviewsFeedData;

export const ReviewsFeedPage = () => {
  const [feedData, setFeedData] = useState<ReviewsFeedData>({ loading: true });
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);

  useEffect(() => {
    (async () => {
      const headers: Record<string, string> = {
        "Content-Type": "application/json",
      };
      if (guest.authenticated) {
        headers["X-SEASONING-TOKEN"] = guest.token;
      }

      setLoading(true);
      const response = await fetch("/api/season-reviews.json", {
        headers: headers,
      });
      setLoading(false);

      if (response.ok) {
        const data = (await response.json()) as { data: LoadedReviewsFeedData["data"] };
        setFeedData({ loading: false, data: data.data });
      } else {
        throw new Error("Could not load reviews");
      }
    })();
  }, []);

  setHeadTitle("Reviews", [feedData]);

  if (!guest.authenticated) {
    return <Navigate to="/" />;
  }

  if (feedData.loading) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <h1 className="text-xl">Reviews</h1>
      <h2 className="text-lg">Recent 10 reviews</h2>
      {feedData.data.map(({ review, show }) => {
        return <SeasonReviewSummary key={review.id} review={review} show={show} />;
      })}
    </div>
  );
};
