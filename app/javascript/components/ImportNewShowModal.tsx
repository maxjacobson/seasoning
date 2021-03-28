import React, { useState, FunctionComponent } from "react"
import { RouteComponentProps, navigate } from "@reach/router"
import { FormLayout, TextField, Modal, TextContainer, InlineError } from "@shopify/polaris"

import { Show } from "../types"

interface Props extends RouteComponentProps {
  token: string
  globalSetLoading: (loadingState: boolean) => void
  active: boolean
  setActive: (newActiveState: boolean) => void
}

const ImportNewShowModal: FunctionComponent<Props> = ({
  token,
  globalSetLoading,
  active,
  setActive,
}: Props) => {
  const [showQuery, setShowQuery] = useState("")
  const [loading, setLoading] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)

  return (
    <Modal
      loading={loading}
      open={active}
      onClose={() => setActive(false)}
      title="Import show"
      primaryAction={{
        content: "Add",
        disabled: loading,
        onAction: () => {
          ;(async () => {
            setLoading(true)
            globalSetLoading(true)
            const response = await fetch("/api/shows.json", {
              body: JSON.stringify({
                shows: {
                  query: showQuery,
                },
              }),
              method: "POST",
              headers: {
                "X-SEASONING-TOKEN": token,
                "Content-Type": "application/json",
              },
            })

            setLoading(false)
            globalSetLoading(false)

            if (response.ok) {
              const data: { show: Show } = await response.json()
              setActive(false)
              navigate(`/shows/${data.show.slug}`)
            } else {
              const data: { error: { message: string } } = await response.json()
              setErrorMessage(data.error.message)
            }
          })()
        },
      }}
    >
      <Modal.Section>
        <TextContainer>
          <p>
            Seasoning is very new. I&rsquo;m sorry to be the one to tell you, but you&rsquo;re an
            early adopter. As such, I&rsquo;m relying on you to help populate our database with
            interesting shows, which will benefit everyone.
          </p>
        </TextContainer>
      </Modal.Section>
      <Modal.Section>
        <FormLayout>
          <TextField
            label="Name of show"
            value={showQuery}
            onChange={setShowQuery}
            id="show-name"
            clearButton={true}
          />
          {errorMessage && <InlineError message={errorMessage} fieldID="show-name" />}
        </FormLayout>
      </Modal.Section>
    </Modal>
  )
}

export default ImportNewShowModal
