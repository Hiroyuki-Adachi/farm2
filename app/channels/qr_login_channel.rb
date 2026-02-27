class QrLoginChannel < ApplicationCable::Channel
  def subscribed
    token = params[:token]
    stream_for token
  end
end
