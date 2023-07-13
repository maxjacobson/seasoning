import { AppWithRouter } from "../App";
import { createElement } from "react";
import { Guest } from "../types";
import { render } from "react-dom";
(async () => {
  const guestToken = localStorage.getItem("seasoning-guest-token");
  let guest: Guest = { authenticated: false };

  if (guestToken) {
    const response = await fetch("/api/guest.json", {
      headers: { "X-SEASONING-TOKEN": guestToken },
    });
    guest = (await response.json()) as Guest;
  }

  render(
    createElement(
      AppWithRouter,
      {
        initialGuest: guest,
      },
      null,
    ),
    document.getElementById("app"),
  );
})();
