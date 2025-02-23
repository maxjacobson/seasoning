import { GuestContext, SetLoadingContext } from "../contexts";
import { loadData, setHeadTitle } from "../hooks";
import { Human } from "../types";
import { useContext } from "react";
import { useParams } from "react-router";

export const ProfileFollowersPage = () => {
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);
  const { handle } = useParams();
  setHeadTitle(`${handle}'s followers`);

  const followersData = loadData<{ humans: Human[] }>(
    guest,
    `/api/profiles/${handle}/followers.json`,
    [],
    setLoading,
  );

  if (followersData.loading) {
    return <div>Loading...</div>;
  }

  if (!followersData.data) {
    return <div>Not found</div>;
  }

  if (followersData.data.humans.length === 0) {
    return (
      <>
        <div>
          <h1 className="text-2xl">{handle}&rsquo;s followers</h1>
          <p>None yet!</p>
        </div>
      </>
    );
  }

  return (
    <div>
      <h1 className="text-2xl">{handle}&rsquo;s followers</h1>
      <ol className="list-inside list-decimal">
        {followersData.data.humans.map((human) => {
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
