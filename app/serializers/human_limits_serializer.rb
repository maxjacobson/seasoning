# What are the state of this person's limits
# For example, if they want to watch no more than 4 shows at a time... how many are they currently watching?
class HumanLimitsSerializer < Oj::Serializer
  object_as :human

  serializer_attributes :currently_watching_limit

  def currently_watching_limit
    {
      current: human.shows.where(my_shows: { status: "currently_watching" }).count,
      max: human.currently_watching_limit
    }
  end
end
