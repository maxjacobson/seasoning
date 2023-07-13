import { Show, YourShow } from "../types";
import { Button } from "./Button";
import { FunctionComponent } from "react";

interface Props {
  show: Show;
  token: string;
  setYourShow: (yourShow: YourShow) => void;
}

export const AddShowButton: FunctionComponent<Props> = ({ show, token, setYourShow }: Props) => {
  return (
    <Button
      onClick={async () => {
        const response = await fetch(`/api/your-shows.json`, {
          headers: {
            "Content-Type": "application/json",
            "X-SEASONING-TOKEN": token,
          },
          body: JSON.stringify({
            show: {
              id: show.id,
            },
          }),
          method: "POST",
        });

        if (response.ok) {
          const data = (await response.json()) as { your_show: YourShow };
          setYourShow(data.your_show);
        } else {
          throw new Error("Could not add show");
        }
      }}
    >
      Add
    </Button>
  );
};
