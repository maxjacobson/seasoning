import "./App.css";

import { BrowserRouter, Link, Route, Routes, useSearchParams } from "react-router";
import { FunctionComponent, useState } from "react";
import { GuestContext, SetLoadingContext } from "./contexts";
import { EpisodePage } from "./pages/EpisodePage";
import { Guest } from "./types";
import { LoadingRibbon } from "./components/LoadingRibbon";
import LogoWithName from "./images/logo-with-name.svg";
import { NewSeasonReviewPage } from "./pages/NewSeasonReviewPage";
import { NotFoundPage } from "./pages/NotFoundPage";
import { ProfileFollowersPage } from "./pages/ProfileFollowersPage";
import { ProfileFollowingPage } from "./pages/ProfileFollowingPage";
import { ProfilePage } from "./pages/ProfilePage";
import { ProfileReviewsPage } from "./pages/ProfileReviewsPage";
import { SeasonPage } from "./pages/SeasonPage";
import { SeasonReviewPage } from "./pages/SeasonReviewPage";
import { ShowPage } from "./pages/ShowPage";

interface Props {
  guest: Guest;
}

const App: FunctionComponent<Props> = ({ guest }: Props) => {
  const [loading, setLoading] = useState(false);
  const [searchParams] = useSearchParams();
  const [searchQuery, setSearchquery] = useState(searchParams.get("q") || "");

  return (
    <>
      <GuestContext.Provider value={guest}>
        <SetLoadingContext.Provider value={setLoading}>
          <>
            {loading && <LoadingRibbon />}

            <div className="mx-1 my-2 flex flex-col justify-between md:flex-row">
              <div className="flex flex-col md:flex-row">
                <a href="/">
                  <img src={LogoWithName} className="h-full" />
                </a>
              </div>
              <div className="pr-2">
                {guest.authenticated && (
                  <form
                    className="md:mr-2 md:inline"
                    onSubmit={(event) => {
                      event.preventDefault();
                      window.location.replace(`/search?q=${encodeURIComponent(searchQuery)}`);
                    }}
                  >
                    <input
                      type="text"
                      placeholder="Search"
                      value={searchQuery}
                      onChange={(event) => setSearchquery(event.target.value)}
                      className="text-field mr-2"
                    />
                    <input type="submit" className="rounded-button" value="Search" />
                  </form>
                )}
                {guest.authenticated && (
                  <>
                    <Link to={`/${guest.human.handle}`} className="mr-2">
                      Your page
                    </Link>
                    <a href="/settings" className="mr-2">
                      Settings
                    </a>
                    <a
                      href="#"
                      onClick={() => {
                        if (confirm("Log out?")) {
                          // hard navigate
                          window.location.pathname = "/logout";
                        }
                      }}
                    >
                      Log out
                    </a>
                  </>
                )}
              </div>
            </div>

            <div className="mx-auto my-0 max-w-2xl p-2">
              <Routes>
                <Route path="/shows/:showSlug" element={<ShowPage />} />
                <Route path="/shows/:showSlug/:seasonSlug" element={<SeasonPage />} />
                <Route
                  path="/shows/:showSlug/:seasonSlug/:episodeNumber"
                  element={<EpisodePage />}
                />
                <Route path="/:handle/shows/:showSlug/:seasonSlug" element={<SeasonReviewPage />} />
                <Route
                  path="/:handle/shows/:showSlug/:seasonSlug/:viewing"
                  element={<SeasonReviewPage />}
                />

                <Route path="/:handle" element={<ProfilePage />} />
                <Route path="/:handle/reviews" element={<ProfileReviewsPage />} />
                <Route path="/:handle/following" element={<ProfileFollowingPage />} />
                <Route path="/:handle/followers" element={<ProfileFollowersPage />} />
                <Route
                  path="/shows/:showSlug/:seasonSlug/reviews/new"
                  element={<NewSeasonReviewPage />}
                />
                <Route path="*" element={<NotFoundPage />} />
              </Routes>

              <div className="mt-5 flex justify-evenly border-t border-dashed border-t-black">
                {guest.authenticated && guest.human.admin && (
                  <>
                    {" "}
                    <a href="/admin">Admin</a>
                  </>
                )}
                {guest.authenticated && (
                  <>
                    <Link to="/reviews">Reviews</Link>{" "}
                  </>
                )}
                <a href="/roadmap">Roadmap</a> <a href="/changelog">Changelog</a>{" "}
                <a href="/credits">Credits</a>
              </div>
            </div>
          </>
        </SetLoadingContext.Provider>
      </GuestContext.Provider>
    </>
  );
};

export const AppWithRouter: FunctionComponent<Props> = (props) => {
  return (
    <BrowserRouter>
      <App {...props} />
    </BrowserRouter>
  );
};
