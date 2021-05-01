import React, { useEffect, useState } from "react"

import { Guest } from "./types"

const DEFAULT_TITLE = "Seasoning"

export const setHeadTitle = (title: string | undefined, deps?: React.DependencyList): void => {
  useEffect(() => {
    document.title = title || DEFAULT_TITLE

    return () => {
      document.title = DEFAULT_TITLE
    }
  }, deps)
}

type LoadableData<T> =
  | { loading: true }
  | { loading: false; data: T }
  | { loading: false; data: null }

export const loadData = <T>(
  guest: Guest,
  url: string,
  deps: React.DependencyList,
  setCurrentlyLoading: (_: boolean) => void
): LoadableData<T> => {
  const [data, setData] = useState<LoadableData<T>>({ loading: true })

  useEffect(() => {
    ;(async () => {
      const headers: Record<string, string> = {}
      if (guest.authenticated) {
        headers["X-SEASONING-TOKEN"] = guest.token
      }
      setCurrentlyLoading(true)
      const response = await fetch(url, {
        headers: headers,
      })
      setCurrentlyLoading(false)

      if (response.ok) {
        const responseData: T = await response.json()
        setData({ loading: false, data: responseData })
      } else if (response.status === 404) {
        setData({ loading: false, data: null })
      } else {
        throw new Error("Could not fetch data")
      }
    })()
  }, deps)

  return data
}
