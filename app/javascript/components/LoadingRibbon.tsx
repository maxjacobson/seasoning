import { FunctionComponent } from "react"

interface Props {
  loading: boolean
}

export const LoadingRibbon: FunctionComponent<Props> = ({ loading }: Props) => {
  if (loading) {
    return <div className="absolute top-0 left-0 h-2.5 w-full bg-slate-500" />
  } else {
    return <></>
  }
}
