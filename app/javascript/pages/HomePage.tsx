import { useContext, useEffect } from "react";
import { GetStarted } from "../components/GetStarted";
import { GuestContext } from "../contexts";
import { useNavigate } from "react-router";

export const HomePage = () => {
  const guest = useContext(GuestContext);

  const navigate = useNavigate();

  useEffect(() => {
    (async () => {
      if (guest.authenticated) {
        await navigate("/shows");
      }
    })();
  }, []);

  if (guest.authenticated) {
    return <div>Loading...</div>;
  } else {
    return (
      <div>
        <h1 className="text-2xl">Welcome</h1>
        <h2 className="text-lg">This is seasoning, a website about TV shows</h2>
        <GetStarted />
      </div>
    );
  }
};
