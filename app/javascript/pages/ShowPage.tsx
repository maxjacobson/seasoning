import { GuestContext, SetLoadingContext } from "../contexts";
import { useContext, useEffect, useState } from "react";
import { AddShowButton } from "../components/AddShowButton";
import { ChooseShowStatusButton } from "../components/ChooseShowStatusButton";
import { MoreInfo } from "../components/MoreInfo";
import { NoteToSelf } from "../components/NoteToSelf";
import { Poster } from "../components/Poster";
import { RemoveShowButton } from "../components/RemoveShowButton";
import { SeasonsList } from "../components/SeasonsList";
import { setHeadTitle } from "../hooks";
import { ShowMetadata } from "../components/ShowMetadata";
import { useParams } from "react-router-dom";
import { YourShow } from "../types";

type LoadingShowData = {
  loading: true;
  data: null;
};

type LoadedShowData = {
  loading: false;
  data: YourShow;
};

type ShowData = LoadingShowData | LoadedShowData;

export const ShowPage = () => {
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);
  const { showSlug } = useParams();
  const [showData, setShowData] = useState<ShowData>({
    loading: true,
    data: null,
  });
  useEffect(() => {
    if (!showSlug) {
      return;
    }

    setLoading(true);
    (async () => {
      let headers;
      if (guest.authenticated) {
        headers = { "X-SEASONING_TOKEN": guest.token };
      } else {
        headers = {};
      }
      const response = await fetch(`/api/shows/${showSlug}.json`, {
        headers: headers,
      });

      setLoading(false);

      if (response.ok) {
        const data: YourShow = await response.json();
        setShowData({ loading: false, data: data });
      } else {
        throw new Error("Could not load show");
      }
    })();
  }, [showSlug]);

  setHeadTitle(showData.loading ? undefined : showData.data.show.title, [showData]);

  if (showData.loading) {
    return (
      <div>
        <h1>Loading show...</h1>
      </div>
    );
  } else {
    const { data } = showData;

    return (
      <div>
        <h1 className="text-2xl">{data.show.title}</h1>

        <MoreInfo url={`https://www.themoviedb.org/tv/${data.show.tmdb_tv_id}`} />

        <div>
          <>
            {guest.authenticated && (
              <span className="mr-2">
                {data.your_relationship ? (
                  <RemoveShowButton
                    show={data.show}
                    token={guest.token}
                    onRemove={() => {
                      setShowData({ loading: false, data: { show: data.show } });
                    }}
                  />
                ) : (
                  <AddShowButton
                    token={guest.token}
                    show={data.show}
                    setYourShow={(yourShow) => {
                      setShowData({ loading: false, data: yourShow });
                    }}
                  />
                )}
              </span>
            )}
          </>
          <>
            {guest.authenticated && data.your_relationship && (
              <ChooseShowStatusButton
                token={guest.token}
                show={data.show}
                yourRelationship={data.your_relationship}
                setYourShow={(yourShow) => {
                  setShowData({ loading: false, data: yourShow });
                }}
              />
            )}
          </>

          {guest.authenticated && data.your_relationship && (
            <div className="my-2">
              <NoteToSelf
                token={guest.token}
                yourShow={data}
                updateYourShow={(newData) => {
                  setShowData({ loading: false, data: newData });
                }}
              />
            </div>
          )}
        </div>

        {data.show.poster_url ? (
          <div>
            <h2 className="text-xl">Poster</h2>
            <Poster show={data.show} size="large" url={data.show.poster_url} />
          </div>
        ) : (
          <div>No poster...</div>
        )}
        {data.show.seasons.length > 0 ? (
          <div>
            <h2 className="text-xl">Seasons</h2>
            <SeasonsList show={data.show} guest={guest} />
          </div>
        ) : (
          <div>No seasons...</div>
        )}

        <ShowMetadata show={data.show} />
      </div>
    );
  }
};
