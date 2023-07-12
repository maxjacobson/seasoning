type Props = Omit<
  React.DetailedHTMLProps<React.InputHTMLAttributes<HTMLInputElement>, HTMLInputElement>,
  "type"
> & {
  inputRef?: React.LegacyRef<HTMLInputElement>;
};

export const Checkbox = (props: Props) => {
  return <input type="checkbox" {...props} className="text-yellow-500" ref={props.inputRef} />;
};
