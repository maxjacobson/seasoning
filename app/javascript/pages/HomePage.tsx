import React, { FunctionComponent, useContext, useEffect } from "react"
import { useNavigate } from "react-router-dom"
import { GetStarted } from "../components/GetStarted"

import { GuestContext } from "../contexts"

interface HomeProps {
  setLoading: (loadingState: boolean) => void
}

export const HomePage: FunctionComponent<HomeProps> = (props: HomeProps) => {
  const { setLoading } = props
  const guest = useContext(GuestContext)

  const navigate = useNavigate()
  useEffect(() => {
    if (guest.authenticated) {
      navigate("/shows")
    }
  }, [])

  if (guest.authenticated) {
    return <div>Loading...</div>
  } else {
    return (
      <div>
        <h1>Welcome</h1>
        <h2>This is seasoning, a website about TV shows</h2>
        <GetStarted globalSetLoading={setLoading} />
      </div>
    )
  }
}
