import { GuestContext, SetLoadingContext } from "../contexts";
import { Link, useParams } from "react-router-dom";
import { useContext, useEffect, useState } from "react";
import { Button } from "../components/Button";
import { Poster } from "../components/Poster";
import { Profile } from "../types";
import { setHeadTitle } from "../hooks";

interface StillLoading {
  loading: true;
}

interface ProfileNotFound {
  loading: false;
  profile: null;
}

interface LoadedProfileData {
  loading: false;
  profile: Profile;
}

type ProfileData = StillLoading | LoadedProfileData | ProfileNotFound;

export const ProfilePage = () => {
  const [profileData, setProfile] = useState<ProfileData>({ loading: true });
  const { handle } = useParams();
  const guest = useContext(GuestContext);
  const setLoading = useContext(SetLoadingContext);

  setHeadTitle(handle);

  useEffect(() => {
    (async () => {
      const headers: Record<string, string> = {};
      if (guest.authenticated) {
        headers["X-SEASONING-TOKEN"] = guest.token;
      }

      setLoading(true);

      const response = await fetch(`/api/profiles/${handle}.json`, { headers: headers });

      setLoading(false);

      if (response.ok) {
        const data = (await response.json()) as { profile: Profile };
        setProfile({
          loading: false,
          profile: data.profile,
        });
      } else if (response.status === 404) {
        setProfile({
          loading: false,
          profile: null,
        });
      } else {
        throw new Error("Could not fetch profile");
      }
    })();
  }, [handle]);

  if (profileData.loading) {
    return <div>Loading...</div>;
  } else if (!profileData.profile) {
    return (
      <div>
        <h1 className="text-xl">Not found</h1>
        <p>No one goes by that name around these parts</p>
      </div>
    );
  } else {
    const { profile } = profileData;

    return (
      <div>
        <h1 className="text-2xl">{handle}</h1>

        {guest.authenticated && profile.your_relationship && !profile.your_relationship.self && (
          <Button
            disabled={profile.your_relationship.you_follow_them}
            onClick={async () => {
              const response = await fetch("/api/follows.json", {
                method: "POST",
                headers: {
                  "X-SEASONING-TOKEN": guest.token,
                  "Content-Type": "application/json",
                },
                body: JSON.stringify({
                  followee: handle,
                }),
              });

              if (!response.ok) {
                throw new Error("Could not follow");
              }

              const data = (await response.json()) as { profile: LoadedProfileData["profile"] };

              setProfile({ loading: false, profile: data.profile });
            }}
          >
            {profile.your_relationship.you_follow_them ? "Following" : "Follow"}
          </Button>
        )}
        <div>
          <>
            <div>
              <p>
                <em>Joined Seasoning on {new Date(profile.created_at).toLocaleDateString()}</em>
              </p>

              <ul className="list-inside list-disc">
                <li className="inline">
                  <Link to={`/${handle}/reviews`}>reviews ({profile.reviews_count})</Link>
                </li>
                <li className="ml-2 inline">
                  <Link to={`/${handle}/followers`}>followers ({profile.followers_count})</Link>
                </li>
                <li className="ml-2 inline">
                  <Link to={`/${handle}/following`}>following ({profile.following_count})</Link>
                </li>
              </ul>
            </div>

            {profile.currently_watching && (
              <div>
                <h2 className="text-xl">Currently watching</h2>
                {profile.currently_watching.length ? (
                  <div className="flex flex-wrap gap-1">
                    {profile.currently_watching.map((show) => {
                      return (
                        <div key={show.id} className="w-32">
                          <Link to={`/shows/${show.slug}`}>
                            <div>
                              <Poster show={show} size="small" url={show.poster_url} />
                            </div>
                            {show.title}
                          </Link>
                        </div>
                      );
                    })}
                  </div>
                ) : (
                  <p>{profile.handle} is not currently watching anything</p>
                )}
              </div>
            )}
          </>
        </div>
      </div>
    );
  }
};
