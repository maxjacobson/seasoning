# Serializes a magic link
class MagicLinkSerializer < Oj::Serializer
  attributes :email
end
