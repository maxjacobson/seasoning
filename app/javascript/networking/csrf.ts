// Reads the token that Rails puts on the page
export const csrfToken = (): string => {
  let token

  const element = document.querySelector("meta[name=csrf-token]")

  if (element) {
    const content = element.attributes.getNamedItem("content")
    if (content) {
      token = content.nodeValue
    }
  }

  if (token) {
    return token
  } else {
    throw new Error("Could not locate csrf token")
  }
}
