# frozen_string_literal: true

# Serializes a magic link
class MagicLinkSerializer < Oj::Serializer
  attributes :email
end
