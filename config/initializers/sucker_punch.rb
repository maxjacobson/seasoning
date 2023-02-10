# frozen_string_literal: true

SuckerPunch.exception_handler = lambda { |ex, klass, args|
  Rails.logger.error <<~MSG.chomp
    SuckerPunch job failed - klass=#{klass} args=#{args.inspect}


    #{ex.inspect}

    #{ex.backtrace&.join("\n")}
  MSG

  Bugsnag.notify(ex) do |event|
    event.add_metadata(
      :sucker_punch,
      {
        klass:,
        args:
      }
    )
  end
}
