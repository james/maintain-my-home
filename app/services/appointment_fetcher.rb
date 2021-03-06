class AppointmentFetcher
  def call(work_order_reference:, limit:)
    @work_order_reference = work_order_reference

    appointments = filter_before_tomorrow(available_appointments)
    appointments = filter_long_slots(appointments)

    if best_slots?(appointments)
      appointments = keep_best_slots_only(appointments)
    end

    appointments.take(limit)
  end

  private

  def available_appointments
    HackneyApi.new.list_available_appointments(
      work_order_reference: @work_order_reference
    )
  end

  def filter_before_tomorrow(appointments)
    tomorrow = 1.day.from_now.at_beginning_of_day

    appointments.select do |appointment|
      Time.zone.parse(appointment.fetch('beginDate')) >= tomorrow
    end
  end

  def filter_long_slots(appointments)
    appointments.reject do |appointment|
      begin_time = Time.zone.parse(appointment.fetch('beginDate'))
      end_time = Time.zone.parse(appointment.fetch('endDate'))
      appointment_length_in_hours = (end_time - begin_time) / 1.hour

      appointment_length_in_hours >= 6
    end
  end

  def keep_best_slots_only(appointments)
    appointments.select do |appointment|
      appointment.fetch('bestSlot') == true
    end
  end

  def best_slots?(appointments)
    appointments.any? { |appointment| appointment.fetch('bestSlot') == true }
  end
end
