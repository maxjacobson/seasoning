import React, { useContext, useEffect } from "react"
import { GetStarted } from "../components/GetStarted"
import { GuestContext } from "../contexts"
import { useNavigate } from "react-router-dom"

export const HomePage = () => {
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
        <GetStarted />
      </div>
    )
  }
}
