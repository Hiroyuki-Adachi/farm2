class QrLoginChannel < ApplicationCable::Channel
  def subscribed
    token = params[:token]
    stream_for token
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
