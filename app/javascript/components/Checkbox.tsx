import React from "react"

// type Props = Omit<React.InputHTMLAttributes<HTMLInputElement>, "className" | "type">

type Props = Omit<
  React.DetailedHTMLProps<React.InputHTMLAttributes<HTMLInputElement>, HTMLInputElement>,
  "type"
>

export const Checkbox = (props: Props) => {
  return <input type="checkbox" {...props} className="text-yellow-500" />
}
