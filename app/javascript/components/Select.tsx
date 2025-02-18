type Props = React.DetailedHTMLProps<
  React.SelectHTMLAttributes<HTMLSelectElement>,
  HTMLSelectElement
>;

export const Select = (props: Props) => {
  return <select {...props} className="select-field" />;
};
