import React, { FunctionComponent } from "react"
import gfm from "remark-gfm"
import ReactMarkdown from "react-markdown"

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
