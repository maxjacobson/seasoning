import { FunctionComponent } from "react"
import gfm from "remark-gfm"
import ReactMarkdown from "react-markdown"

interface Props {
  markdown: string
}

export const Markdown: FunctionComponent<Props> = ({ markdown }: Props) => {
  return (
    <>
      <ReactMarkdown className="rendered-markdown" remarkPlugins={[gfm]}>
        {markdown}
      </ReactMarkdown>
    </>
  )
}
