# app/channels/character_channel.rb
class CharacterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "character_channel_#{params[:id]}"
    Rails.logger.info "CharacterChannel: User #{params[:id]} subscribed"
  end

  def unsubscribed
    stop_all_streams
    Rails.logger.info "CharacterChannel: User #{params[:id]} unsubscribed"
  end
end
