class BookingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "booking_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
