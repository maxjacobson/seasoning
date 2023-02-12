import { FunctionComponent } from "react"

interface Props {
  date: string | null
}

export const AirDate: FunctionComponent<Props> = ({ date: dateStr }: Props) => {
  if (dateStr) {
    const date: Date = new Date(dateStr)

    return <>{date.toLocaleDateString()}</>
  } else {
    return <>&mdash;</>
  }
}
