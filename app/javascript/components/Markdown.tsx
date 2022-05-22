import React, { FunctionComponent } from "react"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"

interface Props {
  markdown: string
}

export const Markdown: FunctionComponent<Props> = ({ markdown }: Props) => {
  return (
    <>
      <ReactMarkdown remarkPlugins={[gfm]}>{markdown}</ReactMarkdown>
    </>
  )
}
