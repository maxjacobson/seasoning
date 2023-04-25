import { FunctionComponent } from "react"

interface Props {
  date: string | null
  available: boolean
}

export const AirDate: FunctionComponent<Props> = ({ date: dateStr, available }: Props) => {
  if (dateStr) {
    const date: Date = new Date(dateStr)
    const dateFormatted = date.toLocaleDateString(undefined, { timeZone: "UTC" })

    if (available) {
      return <span>{dateFormatted}</span>
    } else {
      return <span className="text-slate-400">{dateFormatted}</span>
    }
  } else {
    return <>&mdash;</>
  }
}
