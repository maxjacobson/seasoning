type Props = Omit<
  React.DetailedHTMLProps<React.TextareaHTMLAttributes<HTMLTextAreaElement>, HTMLTextAreaElement>,
  "className"
>;

export const Textarea = (props: Props) => {
  return (
    <textarea {...props} className="h-48 w-5/6 focus:border-yellow-400 focus:ring-yellow-400" />
  );
};
