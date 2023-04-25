type Props = Omit<React.ButtonHTMLAttributes<HTMLButtonElement>, "className">

export const Button = (props: Props) => {
  return (
    <button
      {...props}
      className="cursor-pointer rounded-2xl border border-orange-200 bg-orange-100 px-4 py-1 text-sm font-semibold text-orange-600 hover:border-transparent hover:bg-orange-600 hover:text-white focus:outline-none focus:ring-2 focus:ring-orange-600 focus:ring-offset-2 disabled:cursor-default disabled:hover:border-orange-200 disabled:hover:bg-orange-100 disabled:hover:text-orange-600"
    >
      {props.value || props.children}
    </button>
  )
}
