# frozen_string_literal: true

# Serializes someone's settings
class SettingsSerializer < Oj::Serializer
  attributes :share_currently_watching
end
