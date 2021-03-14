# frozen_string_literal: true

# Serializes the show, in the context of a particular guest, to JSON
class MyShowSerializer < Oj::Serializer
  object_as :my_show

  serializer_attributes :show
  serializer_attributes :your_relationship, if: -> { my_show.persisted? }

  def show
    ShowSerializer.one(my_show.show)
  end

  def your_relationship
    {
      added_at: my_show.created_at
    }
  end
end
