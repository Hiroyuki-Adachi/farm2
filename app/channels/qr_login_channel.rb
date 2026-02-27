class QrLoginChannel < ApplicationCable::Channel
  def subscribed
    token = params[:token]

    if token.blank?
      reject
      return
    end
    stream_for token
  end
end
