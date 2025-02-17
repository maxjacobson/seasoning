type Props = Omit<React.ButtonHTMLAttributes<HTMLButtonElement>, "className">;

export const Button = (props: Props) => {
  return (
    <button {...props} className="rounded-button">
      {props.value || props.children}
    </button>
  );
};
