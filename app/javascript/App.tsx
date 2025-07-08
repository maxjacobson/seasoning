import "./App.css";

import { BrowserRouter, Route, Routes, useSearchParams } from "react-router";
import { FunctionComponent, useState } from "react";
import { GuestContext, SetLoadingContext } from "./contexts";
import { Guest } from "./types";
import { LoadingRibbon } from "./components/LoadingRibbon";
import LogoWithName from "./images/logo-with-name.svg";
import { NotFoundPage } from "./pages/NotFoundPage";
import { SeasonPage } from "./pages/SeasonPage";

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
                      window.location.replace(
                        `/search?q=${encodeURIComponent(searchQuery)}`,
                      );
                    }}
                  >
                    <input
                      type="text"
                      placeholder="Search"
                      value={searchQuery}
                      onChange={(event) => setSearchquery(event.target.value)}
                      className="text-field mr-2"
                    />
                    <input
                      type="submit"
                      className="rounded-button"
                      value="Search"
                    />
                  </form>
                )}
                {guest.authenticated && (
                  <>
                    <a href={`/${guest.human.handle}`} className="mr-2">
                      Your page
                    </a>
                    <a href="/settings" className="mr-2">
                      Settings
                    </a>
                  </>
                )}
              </div>
            </div>

            <div className="mx-auto my-0 max-w-3xl p-2">
              <Routes>
                <Route
                  path="/shows/:showSlug/:seasonSlug"
                  element={<SeasonPage />}
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
                <a href="/roadmap">Roadmap</a>{" "}
                <a href="/changelog">Changelog</a>{" "}
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
