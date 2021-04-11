import React, { FunctionComponent } from "react"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"
import { TextContainer, Heading as PolarisHeading, HeadingTagName } from "@shopify/polaris"

type Level = 1 | 2 | 3 | 4 | 5 | 6

const headingMappings: Record<Level, HeadingTagName> = {
  1: "h1",
  2: "h2",
  3: "h3",
  4: "h4",
  5: "h5",
  6: "h6",
}

const Heading = ({ children, level }: { children: React.ReactNode; level: Level }) => {
  const element: HeadingTagName = headingMappings[level]
  return <PolarisHeading element={element}>{children}</PolarisHeading>
}

// Use the polaris components
//
// This is necessary because polaris resets things like h1 and p tags,
// and it looks bad unless we use polaris's stuff
const renderers = {
  text: TextContainer,
  heading: Heading,
}

interface Props {
  markdown: string
}

const Markdown: FunctionComponent<Props> = ({ markdown }: Props) => {
  return (
    <ReactMarkdown plugins={[gfm]} renderers={renderers}>
      {markdown}
    </ReactMarkdown>
  )
}

export default Markdown
