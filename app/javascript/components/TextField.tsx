type Props = Omit<React.InputHTMLAttributes<HTMLInputElement>, "className" | "type">

export const TextField = (props: Props) => {
  return <input type="text" {...props} className="focus:border-yellow-400 focus:ring-yellow-400" />
}
