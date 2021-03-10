import React from "react"
const Home = ({ guest }) => {
  if (guest) {
    return <p>Welcome home, {guest.name}</p>
  } else {
    return <p>Sign up?</p>
  }
}
export default Home
