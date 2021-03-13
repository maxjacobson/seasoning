import React, { useEffect } from "react"

const DEFAULT_TITLE = "Seasoning"

export const setHeadTitle = (
  title: string | undefined,
  deps?: React.DependencyList
) => {
  useEffect(() => {
    document.title = title || DEFAULT_TITLE

    return () => {
      document.title = DEFAULT_TITLE
    }
  }, deps)
}
