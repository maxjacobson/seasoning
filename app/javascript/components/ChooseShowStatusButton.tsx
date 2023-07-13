import {
  atLimit,
  displayMyShowStatus,
  displayMyShowStatusLimit,
  updateMyShow,
} from "../helpers/my_shows";
import { FunctionComponent, useContext } from "react";
import { GuestContext, SetLoadingContext } from "../contexts";
import { HumanLimits, MyShowStatus, Show, YourRelationshipToShow, YourShow } from "../types";
import { loadData } from "../hooks";
import { Select } from "./Select";

const allStatuses: MyShowStatus[] = [
  "might_watch",
  "next_up",
  "currently_watching",
  "stopped_watching",
  "waiting_for_more",
  "finished",
];

interface Props {
  show: Show;
  yourRelationship: YourRelationshipToShow;
  token: string;
  setYourShow: (yourShow: YourShow) => void;
}

export const ChooseShowStatusButton: FunctionComponent<Props> = ({
  show,
  token,
  yourRelationship,
  setYourShow,
}: Props) => {
  const globalSetLoading = useContext(SetLoadingContext);
  const guest = useContext(GuestContext);

  const limits = loadData<HumanLimits>(
    guest,
    "/api/human-limits.json",
    [yourRelationship.status],
    globalSetLoading,
  );

  if (limits.loading) {
    return <p>Loading...</p>;
  }

  if (!limits.data) {
    throw new Error("Missing limits data");
  }

  return (
    <Select
      value={yourRelationship.status}
      onChange={async (event) => {
        globalSetLoading(true);
        const response = await updateMyShow(show, token, { show: { status: event.target.value } });
        globalSetLoading(false);

        if (response.ok) {
          const data = (await response.json()) as YourShow;
          setYourShow(data);
        } else {
          throw new Error("Could not update status of show");
        }
      }}
    >
      {allStatuses.map((status) => {
        return (
          <option key={status} value={status} disabled={atLimit(status, limits.data)}>
            {displayMyShowStatus(status)} {displayMyShowStatusLimit(status, limits.data)}
          </option>
        );
      })}
    </Select>
  );
};
