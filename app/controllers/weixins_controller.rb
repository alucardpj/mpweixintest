class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def auth
    render :text => params[:echostr]
  end

  # def create
  #   case params[:xml][:MsgType]
  #   when "text"
  #     @reply = params[:xml][:Content]
  #   when "location"
  #     url = "http://api.map.baidu.com/geocoder?location=#{params[:xml][:Location_X]},#{params[:xml][:Location_Y]}&output=json&key=9d303595cfbaa7f96ab0e7f56c1fd29f"
  #     result = JSON::parse(Net::HTTP.get(URI(url)))
  #     @reply = result["result"]["formatted_address"]
  #   when "image"
  #   end
  #   render "textreply", :formats => :xml
  # end

  def reply_text
    @reply = params[:xml][:Content]
    render "reply", formats: :xml
  end

  def reply_image
    render "reply", formats: :xml
  end

  def reply_location
    url = "http://api.map.baidu.com/geocoder?location=#{params[:xml][:Location_X]},#{params[:xml][:Location_Y]}&output=json&key=9d303595cfbaa7f96ab0e7f56c1fd29f"
    result = JSON::parse(Net::HTTP.get(URI(url)))
    @reply = result["result"]["formatted_address"]
    render "reply", formats: :xml
  end

  def reply_link
    render "reply", formats: :xml
  end

  def reply_event
    render "reply", formats: :xml
  end

  def reply_music
    render "reply", formats: :xml
  end

  def reply_news
    render "reply", formats: :xml
  end

  private
  def check_weixin_legality
    array = [Setting.token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
