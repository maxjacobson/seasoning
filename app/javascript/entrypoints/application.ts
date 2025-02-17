import { AppWithRouter } from "../App";
import { createElement } from "react";
import { createRoot } from "react-dom/client";
import { Guest } from "../types";

(async () => {
  const container = document.getElementById("app");

  const guestToken = container?.dataset?.token;
  let guest: Guest = { authenticated: false };

  if (guestToken) {
    const response = await fetch("/api/guest.json", {
      headers: { "X-SEASONING-TOKEN": guestToken },
    });
    guest = (await response.json()) as Guest;
  }

  if (container) {
    const root = createRoot(container);
    root.render(
      createElement(
        AppWithRouter,
        {
          guest: guest,
        },
        null,
      ),
    );
  }
})();
