import { GuestContext } from "../contexts";
import { Link } from "react-router";
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
          <Link to="/">Go home</Link>
        </div>
      )}
    </div>
  );
};
