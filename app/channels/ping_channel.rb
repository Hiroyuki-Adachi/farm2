# app/channels/ping_channel.rb
class PingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ping"
  end
end
