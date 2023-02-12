import React from "react"

type Props = React.DetailedHTMLProps<
  React.SelectHTMLAttributes<HTMLSelectElement>,
  HTMLSelectElement
>

export const Select = (props: Props) => {
  return <select {...props} className="focus:border-yellow-400 focus:ring-yellow-400" />
}
