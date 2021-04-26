import React, { FunctionComponent } from "react"
import ReactMarkdown from "react-markdown"
import gfm from "remark-gfm"
import {
  TextContainer,
  HeadingTagName,
  Subheading as PolarisSubheading,
  TextStyle,
  Link,
} from "@shopify/polaris"

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

  return <PolarisSubheading element={element}>{children}</PolarisSubheading>
}

const InlineCode = ({ children }: { children: string }) => {
  return <TextStyle variation="code">{children}</TextStyle>
}

const MarkdownLink = ({ children, href }: { href: string; children: React.ReactNode }) => {
  return (
    <Link url={href} external={true}>
      {children}
    </Link>
  )
}

// Use the polaris components
//
// This is necessary because polaris resets things like h1 and p tags,
// and it looks bad unless we use polaris's stuff
const renderers = {
  heading: Heading,
  inlineCode: InlineCode,
  link: MarkdownLink,
}

interface Props {
  markdown: string
}

export const Markdown: FunctionComponent<Props> = ({ markdown }: Props) => {
  return (
    <TextContainer>
      <ReactMarkdown plugins={[gfm]} renderers={renderers}>
        {markdown}
      </ReactMarkdown>
    </TextContainer>
  )
}
