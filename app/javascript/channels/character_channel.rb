# app/channels/character_channel.rb
class CharacterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "character_channel_#{params[:character_id]}"
    puts "User subscribed to character_channel_#{params[:character_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
    puts "User unsubscribed from character_channel_#{params[:character_id]}"
  end
end
