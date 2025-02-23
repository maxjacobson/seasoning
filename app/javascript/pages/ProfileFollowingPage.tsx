import { GuestContext, SetLoadingContext } from "../contexts";
import { loadData, setHeadTitle } from "../hooks";
import { Human } from "../types";
import { useContext } from "react";
import { useParams } from "react-router";

export const ProfileFollowingPage = () => {
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);
  const { handle } = useParams();
  setHeadTitle(`${handle}'s follows`);

  const followingData = loadData<{ humans: Human[] }>(
    guest,
    `/api/profiles/${handle}/following.json`,
    [],
    setLoading,
  );

  if (followingData.loading) {
    return <div>Loading...</div>;
  }

  if (!followingData.data) {
    return <div>Not found</div>;
  }

  if (followingData.data.humans.length === 0) {
    return (
      <>
        <div>
          <h1 className="text-2xl">{handle}&rsquo;s follows</h1>
          <p>None yet!</p>
        </div>
      </>
    );
  }

  return (
    <div>
      <h1 className="text-2xl">{handle}&rsquo;s follows</h1>
      <ol className="list-inside list-decimal">
        {followingData.data.humans.map((human) => {
          return (
            <li key={human.handle}>
              <a href={`/${human.handle}`}>{human.handle}</a>
            </li>
          );
        })}
      </ol>
    </div>
  );
};
