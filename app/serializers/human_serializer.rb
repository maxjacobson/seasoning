# Serializes a human
class HumanSerializer < Oj::Serializer
  object_as :human

  attributes(
    :handle,
    :admin
  )
end
