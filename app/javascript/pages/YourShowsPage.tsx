import { GuestContext } from "../contexts";
import { useContext } from "react";
import { YourShowsList } from "../components/YourShowsList";

export const YourShowsPage = () => {
  const guest = useContext(GuestContext);

  return (
    <div>
      <h1 className="text-xl">Your shows</h1>
      {guest.authenticated ? (
        <YourShowsList human={guest.human} token={guest.token} />
      ) : (
        <div>
          <a href="/">Go home</a>
        </div>
      )}
    </div>
  );
};
