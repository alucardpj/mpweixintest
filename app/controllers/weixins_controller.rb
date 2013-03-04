class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def index
    render :text => params[:echostr]
  end

  def create
    # if params[:xml][:MsgType] == "text"
    #   render "echo", :formats => :xml
    # end
    case params[:xml][:MsgType]
    when "text"
      @reply = params[:xml][:Content]
    when "location"
      url = "http://api.map.baidu.com/geocoder?location=#{params[:xml][:Location_X]},#{params[:xml][:Location_Y]}&output=json&key=9d303595cfbaa7f96ab0e7f56c1fd29f"
      result = JSON::parse(Net::HTTP.get(URI(url)))
      @reply = result["result"]["formatted_address"]
    end
    render "textreply", :formats => :xml
  end

  private
  def check_weixin_legality
    array = [Setting.token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
