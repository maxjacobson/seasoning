import { GuestContext, SetLoadingContext } from "../contexts";
import { HumanSettings, Rating, SeasonReview, Visibility, YourSeason } from "../types";
import { loadData, setHeadTitle } from "../hooks";
import { useContext, useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { Button } from "../components/Button";
import { Select } from "../components/Select";
import { Textarea } from "../components/Textarea";

export const NewSeasonReviewPage = () => {
  const [body, setBody] = useState("");
  const [visibility, setVisibility] = useState<Visibility | undefined>(undefined);
  const [rating, setRating] = useState<Rating | undefined>(undefined);
  const [validationError, setValidationError] = useState<null | Record<string, string[]>>(null);
  const { showSlug, seasonSlug } = useParams();
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);

  const settings = loadData<HumanSettings>(guest, "/api/settings.json", [], setLoading);

  const navigate = useNavigate();

  useEffect(() => {
    if (!settings.loading) {
      setVisibility(settings.data?.default_review_visibility);
    }
  }, [settings]);

  const yourSeason = loadData<YourSeason>(
    guest,
    `/api/shows/${showSlug}/seasons/${seasonSlug}.json`,
    [showSlug, seasonSlug],
    setLoading,
  );

  setHeadTitle("New review");

  if (settings.loading || yourSeason.loading) {
    return <div>Loading...</div>;
  }

  if (!settings.data || !yourSeason.data || !guest.authenticated) {
    return <div>Not found</div>;
  }

  return (
    <div>
      <h1 className="mb-2 text-2xl">
        New review of {yourSeason.data.show.title} &mdash; {yourSeason.data.season.name}
      </h1>

      <label className="mr-2">Visible to</label>
      <Select
        value={visibility}
        onChange={(event) => setVisibility(event.target.value as Visibility)}
        disabled={!visibility}
      >
        <option value="anybody">Anybody</option>
        <option value="mutuals">Mutual follows</option>
        <option value="myself">Only myself</option>
      </Select>

      <RatingPicker rating={rating} setRating={setRating} />

      <label>
        <span>
          Your review (you can use{" "}
          <a href="https://commonmark.org/help/" target="_blank" rel="noreferrer">
            Markdown
          </a>
          )
        </span>
      </label>
      <div>
        <Textarea value={body} onChange={(event) => setBody(event.target.value)} />
      </div>
      <div>
        <Button
          disabled={!visibility}
          onClick={async () => {
            setLoading(true);
            const response = await fetch("/api/season-reviews.json", {
              method: "POST",
              headers: {
                "X-SEASONING-TOKEN": guest.token,
                "Content-Type": "application/json",
              },
              body: JSON.stringify({
                review: {
                  body: body,
                  visibility: visibility,
                  rating: rating,
                },
                show_id: yourSeason.data.show.id,
                season_id: yourSeason.data.season.id,
              }),
            });
            setLoading(false);

            if (response.ok) {
              const data = await response.json();
              const review: SeasonReview = data.review;
              const url = `/${guest.human.handle}/shows/${showSlug}/${seasonSlug}${
                review.viewing === 1 ? "" : `/${review.viewing}`
              }`;
              navigate(url);
            } else if (response.status === 400) {
              const data = await response.json();
              setValidationError(data);
            } else {
              throw new Error("Could not create review");
            }
          }}
        >
          Save
        </Button>
      </div>

      {validationError &&
        Object.keys(validationError).map((key) => {
          return (
            <>
              {validationError[key].map((errorMessage, i) => {
                return (
                  <div key={i}>
                    {key} {errorMessage}
                  </div>
                );
              })}
            </>
          );
        })}
    </div>
  );
};

const RatingPicker = ({
  rating,
  setRating,
}: {
  rating: Rating | undefined;
  setRating: (_: Rating | undefined) => void;
}) => {
  const choiceProps = {
    choice: rating,
    setChoice: setRating,
  };

  return (
    <>
      <div className="text-xl">
        <RatingChoice position={1} {...choiceProps} />
        <RatingChoice position={2} {...choiceProps} />
        <RatingChoice position={3} {...choiceProps} />
        <RatingChoice position={4} {...choiceProps} />
        <RatingChoice position={5} {...choiceProps} />
        <RatingChoice position={6} {...choiceProps} />
        <RatingChoice position={7} {...choiceProps} />
        <RatingChoice position={8} {...choiceProps} />
        <RatingChoice position={9} {...choiceProps} />
        <RatingChoice position={10} {...choiceProps} />
        <span className="cursor-pointer" onClick={() => setRating(undefined)}>
          🚫
        </span>
      </div>
      <div>{rating ? `Rating: ${rating}` : "No rating"}</div>
    </>
  );
};

const RatingChoice = ({
  position,
  setChoice,
  choice,
}: {
  position: Rating;
  setChoice: (_: Rating | undefined) => void;
  choice: Rating | undefined;
}) => {
  const starProps = {
    onClick: () => setChoice(position),
  };

  if (choice && choice >= position) {
    return (
      <span {...starProps} className="cursor-pointer text-yellow-400">
        ★
      </span>
    );
  } else {
    return (
      <span {...starProps} className="cursor-pointer">
        ☆
      </span>
    );
  }
};
