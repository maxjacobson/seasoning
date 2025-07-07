import { AppWithRouter } from "../App";
import { createElement } from "react";
import { createRoot } from "react-dom/client";
import { Guest } from "../types";

(async () => {
  const container = document.getElementById("app");

  let guest: Guest = { authenticated: false };

  const response = await fetch("/api/guest.json", {
    credentials: "same-origin",
  });
  guest = (await response.json()) as Guest;

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
