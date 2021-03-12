import { useEffect } from "react"

export const setHeadTitle = (title: string) => {
  useEffect(() => {
    document.title = title

    return () => {
      document.title = "Seasoning"
    }
  }, [])
}
