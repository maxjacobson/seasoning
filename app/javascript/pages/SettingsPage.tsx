import { AuthenticatedGuest, HumanSettings } from "../types";
import { FunctionComponent, useContext, useEffect, useState } from "react";
import { GuestContext, SetLoadingContext } from "../contexts";
import { Checkbox } from "../components/Checkbox";
import { Select } from "../components/Select";
import { setHeadTitle } from "../hooks";

interface LoadingSettingsData {
  loading: true;
}

interface LoadedSettingsData {
  loading: false;
  settings: HumanSettings;
}

type SettingsData = LoadingSettingsData | LoadedSettingsData;

export const SettingsPage = () => {
  setHeadTitle("Settings");

  return (
    <div>
      <h1 className="text-2xl">Settings</h1>
      <SettingsBody />
    </div>
  );
};

const SettingsBody = () => {
  const guest = useContext(GuestContext);

  return (
    <div>
      {guest.authenticated ? (
        <EditSettings guest={guest} />
      ) : (
        <div>
          <p>You need to log in to edit your settings!</p>
        </div>
      )}
    </div>
  );
};

interface EditSettingsProps {
  guest: AuthenticatedGuest;
}

const EditSettings: FunctionComponent<EditSettingsProps> = ({ guest }: EditSettingsProps) => {
  const [currentlyUpdating, setCurrentlyUpdating] = useState(false);
  const [settingsData, setSettingsData] = useState<SettingsData>({ loading: true });
  const setLoading = useContext(SetLoadingContext);

  useEffect(() => {
    (async () => {
      setLoading(true);
      const response = await fetch("/api/settings.json", {
        headers: {
          "X-SEASONING-TOKEN": guest.token,
        },
      });
      setLoading(false);

      if (response.ok) {
        const data = (await response.json()) as HumanSettings;
        setSettingsData({ loading: false, settings: data });
      } else {
        throw new Error("Could not load settings");
      }
    })();
  }, []);

  const update = async (patch: Record<string, unknown>) => {
    setCurrentlyUpdating(true);
    setLoading(true);
    const response = await updateMySettings(guest.token, patch);
    setCurrentlyUpdating(false);
    setLoading(false);

    if (response.ok) {
      const data = (await response.json()) as HumanSettings;
      setSettingsData({ loading: false, settings: data });
    } else {
      throw new Error("Could not update settings");
    }
  };

  if (settingsData.loading) {
    return <div>Loading settings...</div>;
  }

  return (
    <>
      <div className="my-6">
        <h2 className="text-xl">Profile page</h2>
        <Checkbox
          name="share-currently-watching"
          id="share-currently-watching"
          checked={settingsData.settings.share_currently_watching}
          disabled={currentlyUpdating}
          onChange={() =>
            update({ share_currently_watching: !settingsData.settings.share_currently_watching })
          }
        />

        <label htmlFor="share-currently-watching" className="ml-2">
          Share the shows I&rsquo;m currently watching
        </label>
      </div>

      <div className="my-6">
        <h2 className="text-xl">Reviews</h2>

        <div>
          <label>Who should new reviews be visible to?</label>
        </div>
        <Select
          value={settingsData.settings.default_review_visibility}
          onChange={async (event) => {
            await update({ default_review_visibility: event.target.value });
          }}
          disabled={currentlyUpdating}
        >
          <option value="anybody">Anybody</option>
          <option value="mutuals">Mutual follows</option>
          <option value="myself">Only myself</option>
        </Select>
        <p>
          This is just a default for new reviews, you can pick another visibility on a
          review-by-review basis!
        </p>
      </div>

      <div className="my-6">
        <h2 className="text-xl">Limits</h2>

        <div>
          <label>Currently watching limit</label>
        </div>

        <Select
          value={settingsData.settings.currently_watching_limit || -1}
          onChange={async (event) => {
            const value = event.target.value;
            if (parseInt(value) > 0) {
              await update({ currently_watching_limit: value });
            } else {
              await update({ currently_watching_limit: null });
            }
          }}
          disabled={currentlyUpdating}
        >
          <option value={-1}>None</option>
          <option value={1}>1</option>
          <option value={2}>2</option>
          <option value={3}>3</option>
          <option value={4}>4</option>
          <option value={5}>5</option>
          <option value={6}>6</option>
          <option value={7}>7</option>
          <option value={8}>8</option>
          <option value={9}>9</option>
          <option value={10}>10</option>
        </Select>
      </div>
    </>
  );
};

const updateMySettings = (token: string, body: Record<string, unknown>): Promise<Response> => {
  return fetch("/api/settings.json", {
    method: "PATCH",
    body: JSON.stringify(body),
    headers: {
      "X-SEASONING-TOKEN": token,
      "Content-Type": "application/json",
    },
  });
};
