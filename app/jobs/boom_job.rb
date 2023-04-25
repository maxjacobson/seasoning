# frozen_string_literal: true

# Dummy class that raises, to help test suckerpunch error handling
class BoomJob
  include SuckerPunch::Job

  def perform(arg)
    raise arg.inspect
  end
end
