# frozen_string_literal: true

# Serializes someone's settings
class SettingsSerializer < Oj::Serializer
  attributes(
    :currently_watching_limit,
    :default_review_visibility,
    :share_currently_watching
  )
end
