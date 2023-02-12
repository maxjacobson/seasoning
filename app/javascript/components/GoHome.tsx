import { FunctionComponent } from "react"
import { Link } from "react-router-dom"

export const GoHome: FunctionComponent<Record<string, never>> = () => {
  return (
    <>
      <p>
        <Link to="/">Go home</Link>
      </p>
    </>
  )
}
