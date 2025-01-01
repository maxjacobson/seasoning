import { AppWithRouter } from "../App";
import { createElement } from "react";
import { createRoot } from "react-dom/client";
import { Guest } from "../types";

(async () => {
  const guestToken = localStorage.getItem("seasoning-guest-token");
  let guest: Guest = { authenticated: false };

  if (guestToken) {
    const response = await fetch("/api/guest.json", {
      headers: { "X-SEASONING-TOKEN": guestToken },
    });
    guest = (await response.json()) as Guest;
  }

  const container = document.getElementById("app");

  if (container) {
    const root = createRoot(container);
    root.render(
      createElement(
        AppWithRouter,
        {
          initialGuest: guest,
        },
        null,
      ),
    );
  }
})();
