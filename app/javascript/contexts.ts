import { createContext } from "react";
import { Guest } from "./types";

export const GuestContext = createContext<Guest>({ authenticated: false });
export const SetLoadingContext = createContext((_: boolean) => {
  // no-op
});
