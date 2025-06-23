import { FunctionComponent } from "react";

const isAvailable = (dateStr: string): boolean => {
  const inputDate = new Date(
    parseInt(dateStr.split("-")[0]), // year
    parseInt(dateStr.split("-")[1]) - 1, // month (0-indexed in JavaScript)
    parseInt(dateStr.split("-")[2]), // day
  );
  const today = new Date();

  const inputDateWithoutTime = new Date(
    inputDate.getFullYear(),
    inputDate.getMonth(),
    inputDate.getDate(),
  );
  const todayWithoutTime = new Date(
    today.getFullYear(),
    today.getMonth(),
    today.getDate(),
  );

  return inputDateWithoutTime <= todayWithoutTime;
};

interface Props {
  date: string | null;
}

export const AirDate: FunctionComponent<Props> = ({ date: dateStr }: Props) => {
  if (dateStr) {
    const inputDate = new Date(dateStr + "T00:00:00");

    const dateFormatted = new Intl.DateTimeFormat("en-US", {
      month: "2-digit",
      day: "2-digit",
      year: "numeric",
    }).format(inputDate);

    const available = isAvailable(dateStr);

    if (available) {
      return <span>{dateFormatted}</span>;
    } else {
      return <span className="text-slate-400">{dateFormatted}</span>;
    }
  } else {
    return <>&mdash;</>;
  }
};
