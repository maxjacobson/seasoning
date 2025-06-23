type Props = Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  "className" | "type"
>;

export const TextField = (props: Props) => {
  return <input type="text" {...props} className="text-field" />;
};
